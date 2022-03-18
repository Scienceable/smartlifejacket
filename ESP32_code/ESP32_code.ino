#include <ESP32Servo.h>
#include <TinyGPS++.h>

Servo servo1;

int servo1Pin = 18;

int minUs = 1000;
int maxUs = 2000;

static const int RXPin = 16, TXPin = 17;
static const uint32_t GPSBaud = 9600;

// The TinyGPS++ object
TinyGPSPlus gps;

// The serial connection to the GPS device

#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif

#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include <addons/TokenHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID ""
#define WIFI_PASSWORD ""

/* 2. Define the API Key */
#define API_KEY ""

/* 3. Define the project ID */
#define FIREBASE_PROJECT_ID ""

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL ""
#define USER_PASSWORD ""

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long dataMillis = 0;
int count = 0;

int times = 0;

//The Firestore payload upload callback function
void fcsUploadCallback(CFS_UploadStatusInfo info)
{
  if (info.status == fb_esp_cfs_upload_status_init)
  {
    Serial.printf("\nUploading data (%d)...\n", info.size);
  }
  else if (info.status == fb_esp_cfs_upload_status_upload)
  {
    Serial.printf("Uploaded %d%s\n", (int)info.progress, "%");
  }
  else if (info.status == fb_esp_cfs_upload_status_complete)
  {
    Serial.println("Upload completed ");
  }
  else if (info.status == fb_esp_cfs_upload_status_process_response)
  {
    Serial.print("Processing the response... ");
  }
  else if (info.status == fb_esp_cfs_upload_status_error)
  {
    Serial.printf("Upload failed, %s\n", info.errorMsg.c_str());
  }
}

String isActivatedcontent = "";
bool isActivated = false;
bool isConfirmed = false;

void setup()
{

  ESP32PWM::allocateTimer(0);


  Serial.begin(115200);
  Serial1.begin(GPSBaud, SERIAL_8N1, RXPin, TXPin);

  servo1.setPeriodHertz(50);


  pinMode(2, OUTPUT);
  pinMode(23, OUTPUT);
  pinMode(22, INPUT);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  Firebase.begin(&config, &auth);

  Firebase.reconnectWiFi(true);

  //For sending payload callback
  //config.cfs.upload_callback = fcsUploadCallback;

  digitalWrite(2, LOW);

}

void loop() {
  digitalWrite(2, LOW);
  servo1.attach(servo1Pin, minUs, maxUs);
  if ((isActivated == false) and (isConfirmed == false)) {
    digitalWrite(23, LOW);
    servo1.write(0);
    servo2.write(0);
    if (Firebase.ready())
    {
      String documentPathGet = "projects/1";
      String isActivatedGet = "isActivated";

      //If the document path contains space e.g. "a b c/d e f"
      //It should encode the space as %20 then the path will be "a%20b%20c/d%20e%20f"

      Serial.print("Get a document... ");

      if (Firebase.Firestore.getDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPathGet.c_str(), isActivatedGet.c_str())) {
        isActivatedcontent = fbdo.payload();
        Serial.println(isActivatedcontent);
        if (isActivatedcontent.indexOf("false") > 0) {
          isActivated = false;
        } else if (isActivatedcontent.indexOf("true") > 0) {
          isConfirmed = true;
        } else {
          isActivated = false;
        }

        Serial.println(isActivated);
      }
      else
        Serial.println(fbdo.errorReason());
    }
  } else if ((isConfirmed == true) and (isActivated == false)) {
    for (times = 0; times < 10; times++) {
      digitalWrite(23, HIGH);
      int stateButton = digitalRead(22);
      if (stateButton == 1) {
        if (Firebase.ready())
        {
          digitalWrite(2, HIGH);

          FirebaseJson content;

          String documentPath = "projects/1";

          String doc_path = "projects/";
          doc_path += FIREBASE_PROJECT_ID;
          doc_path += "/databases/(default)/documents/coll_id/doc_id"; //coll_id and doc_id are your collection id and document id

          content.set("fields/isActivated/booleanValue", false);

          Serial.print("Update a document... ");

          if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "" /* databaseId can be (default) or empty */, documentPath.c_str(), content.raw(), "isActivated"))
            Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
          else
            Serial.println(fbdo.errorReason());

          isConfirmed == false;
          times = 11;
          break;
        }
      }
      delay (1000);
      digitalWrite(23, LOW);
      delay (1000);
      Serial.println(times);
    }
    isActivated = true;
    
  } else if (isActivated == true) {

    smartDelay(1000);
    if (millis() > 5000 && gps.charsProcessed() < 10)
      Serial.println(F("No GPS data received: check wiring"));
    servo1.write(180);
    servo2.write(180);

    if (Firebase.ready())
    {
      digitalWrite(2, HIGH);

      //For the usage of FirebaseJson, see examples/FirebaseJson/BasicUsage/Create.ino
      FirebaseJson content;

      //We will create the nested document in the parent path "a0/b0/c0
      //a0 is the collection id, b0 is the document id in collection a0 and c0 is the collection id in the document b0.
      //and d? is the document id in the document collection id c0 which we will create.
      String documentPath = "projects/1";

      //If the document path contains space e.g. "a b c/d e f"
      //It should encode the space as %20 then the path will be "a%20b%20c/d%20e%20f"


      String doc_path = "projects/";
      doc_path += FIREBASE_PROJECT_ID;
      doc_path += "/databases/(default)/documents/coll_id/doc_id"; //coll_id and doc_id are your collection id and document id


      //lat long
      content.set("fields/deviceCoordinates/geoPointValue/latitude", gps.location.lat());
      content.set("fields/deviceCoordinates/geoPointValue/longitude", gps.location.lng());

      Serial.print("Update a document... ");

      if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "" /* databaseId can be (default) or empty */, documentPath.c_str(), content.raw(), "deviceCoordinates"))
        Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
      else
        Serial.println(fbdo.errorReason());

      String documentPathGet = "projects/1";
      String isActivatedGet = "isActivated";

      //If the document path contains space e.g. "a b c/d e f"
      //It should encode the space as %20 then the path will be "a%20b%20c/d%20e%20f"

      Serial.print("Get a document... ");

      if (Firebase.Firestore.getDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPathGet.c_str(), isActivatedGet.c_str())) {
        isActivatedcontent = fbdo.payload();
        Serial.println(isActivatedcontent);
        if (isActivatedcontent.indexOf("false") > 0) {
          isActivated = false;
          isConfirmed = false;
        } else if (isActivatedcontent.indexOf("true") > 0) {
          isActivated = true;
        } else {
          isActivated = false;
          isConfirmed = false;
        }

        Serial.println(isActivated);
      }
      else
        Serial.println(fbdo.errorReason());
    }
  }
}

static void smartDelay(unsigned long ms)
{
  unsigned long start = millis();
  do
  {
    while (Serial1.available())
      gps.encode(Serial1.read());
  } while (millis() - start < ms);
}

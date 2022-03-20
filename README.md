# SmartLifeJacket
SmartLifeJacket
**Abstract**
Around the world, 236,000 people in 2019 died from drowning. Annually, 3,960 fatal unintentional drownings occur in the United States - an average of 11 deaths every day. In Canada, from 2011 to 2015, there are a total of 2,231 deaths due to drowning, 39% and 41% of the deaths are alcohol-related for individuals from 15 to 24 years of age and above 25 years of age respectively. Drowning is also one of the leading causes of injury-related deaths among children in Canada. Therefore, this threat impacts the most on the impaired or unskilled individuals. Notably, more than 20% of the deaths are in a natural body of water, where search and rescue efforts are more difficult. Even situated inside a more controlled environment, the majority of drownings occur in public and residential swimming pools - accounting for 55% of drownings in Canada. Life jackets and personal floatation devices (PFDs) offer a solution to the issue, yet they are often not being worn in 87%, 75%, and 80% (up to 100% in Alberta) of drownings as a young adult, middle-aged adult, and older adult respectively. The top reason victims refrain from wearing them is that they restrict movement while swimming. According to a report from Alberta, drownings cost $25 million dollars from 1999 to 2019. This information urged for a solution to this existing problem. Therefore, our team will attempt to tackle it, for the better of those who continue to maintain a healthy lifestyle in aquatic environments.

**Procedure**
We decided on inventing a new product based on pre-existing products with additional capabilities. Our team aims to offer a life jacket, that when in the stowed position, is deflated. When worn and swimming, the life jacket continues to remain deflated, enabling users to swim without restrictions. However, when a potential for drowning is detected, the life jacket will automatically inflate. The jacket can be manually inflated as well. Locations will be sent wirelessly for search and rescue personnel, especially incidents in a natural water environment. Emergency services are also automatically contacted after a period where users did not intervene. The automation aids impaired and unskilled swimmers to stay afloat, preventing drowning from occurring. A compliment app can be developed in order to look up the location of the device, where afterwards, search and rescue can pinpoint the user's current location. This is the logbook for the work invested toward the project.
**
Technical insights**
SmartLifeJacket’s inner-workings are based upon the harmony across many components. During normal operations, water depth sensors will collect the data of the depth of water at its current location. Microphone sensor will record the sound from the surroundings and oxygen saturation and heart pulse sensor will measure oxygen saturation and heart rate of the user. The information from the sensors will be sent to a microcontroller, where they would be processed. SmartLifeJacket has an ability for users to change the sensitivity of the device. With high sensibility, lower water depth will trigger the automatic inflation of the life jacket. Sound from the microphone will be analyzed against a database of experimental values. When it is closely matched with the environment where someone is in distress, inflation of the life jacket will be triggered automatically as well. Lastly, lower than normal values of oxygen saturation and higher than normal values of heart pulse is also a justification for the life jacket to automatically inflate. To reflect the most accurate values, the “normal values'' will be averaged during swimming, not during rest. Before such automatic inflation however, LEDs will be turned on as an indication as the inflation will begin shortly. The user, henceforth, can cancel the automatic inflation by pressing a button in a timely manner. Otherwise, the life jacket will inflate, thus saving the user from drowning. The same button can be used to manually inflate the SmartLifeJacket. After inflation, the device will automatically contact a GPS satellite to collect the location data, and call emergency services and provide them with the GPS information. SmartLifeJacket also implements the Internet of Things (IoT) technology. Through satellite communication, it reads and writes data on a cloud, which an app can be made available to read and write that data as well. This permits search and rescue personnel to find the user via the app, or the user can adjust the sensibility of SmartLifeJacket.
We decided to use CO2 cartridges to inflate SmartLifeJacket . To find the correct cartridge size, the magnitude of gravitational force of an average person (~100 kg) needs to be found, 
Fg=mg =(100 kg)(9.81 m/s2)=981 N 
The buoyant force created from the CO2 gas needs to be at least equal to the magnitude of gravitational force, therefore, Fb = Fg. However, because the human body of 100 kg, with an overestimate density of 1100 kg/m3 (the higher the density of the user body, the harder for the user to float naturally), which create a significant buoyant force in water, 
Fb of body=pwatermpbodyg(1000 kg/m3)(100 kg1100 kg/m3)(9.81 m/s2)=892 N
Therefore, the life jacket doesn’t need to create as much force as the gravitational force. Furthermore, we also need to find the volume that is needed to be displaced in water to create such buoyant force, 
Fb=Fg-Fb of body=pwaterVgV=Fg-Fb of bodypwaterg=Fg-Fb of body(1000 kg/m3)(9.81 m/s2)=9.09 L
The amount of moles of CO2 to take up such space in Standard Ambient Temperature and Pressure, SATP conditions (25 degrees Celsius (298.15 K) and 101.325 kPa) is:
	PV=nRT n=PVRT=(101.325 kPa)V(8.314 L⋅kPa⋅K-1⋅mol-1)(298.15 K)=0.372 mol 
Therefore, the mass of CO2 required is 16.4g.
Prototyping and Conclusion
	Refer to the electrical schematic for the detailed wiring of the prototype. In short, a LiPo battery is connected to the buck-boost converter so a steady 5V can be used efficiently. 5V is used to power a servo to stimulate the release of CO2 into the life jacket. LM1084IT-3.3 is used to step the voltage further down to 3.3V for the ESP32 and BN220. ESP32 will directly control the servo via PWM and BN220 through serial communication. A mobile application is also made through Flutter and Dart in order to control the hardware. It communicates with the ESP32 through WiFi, in the realm of the IoT system, where Cloud Firestore acts as the cloud, or the “middle man” of the communication. TensorFlow Lite is also used in the application to detect voices of the user saying “help” through Machine Learning, hence remotely triggering the hardware to activate. All program codes can be observed here.

During testing, the Machine Learning algorithm is subjected to: 1) 10 attempts of saying “help”, all 10 attempts correctly identify them, indicating a 0% false negative rate. 2) 10 attempts of producing random noises that do not indicate any help is necessary, 6 attempts correctly identify them, indicating a 40% false positive rate. After the initial activation, ESP32 successfully: 1) Order the LED to blink so the user can be notified. 2) Receive the message from the push button to cancel the activation sequence. 3) Collect GPS data and upload them onto Cloud Firestore. 4) Order the servo to turn, indicating that such CO2 release should be successful. For the mobile application, it successfully: 1) Collect GPS data uploaded onto Cloud Firestore and portray them onto the Google Maps plugin that have been integrated within the app. 2) Cancel and reset the activation sequence if necessary.
Acknowledgments
We would like to acknowledge Mrs. Lindsay Barton, Mr. Philip Eriksson, Mr. Raymond Mitchell, Ms. Jessica Mohan, Mrs. Danielle Peters, Mr. Terrance Prescesky and Mary Searle who provided us with continuing support and encouraging guidance throughout the project. In addition, our families, peers, and the local community make this project possible. We would like to express our utmost gratitude toward everyone who contributed to our project’s success.
**
References and bibliography**

World Health Organization. (2021, April 27). Drowning. World Health Organization. Retrieved January 6, 2022, from https://www.who.int/news-room/fact-sheets/detail/drowning  


Canadian Red Cross. (2020). Deaths by immersion - Red Cross. DEATHS BY IMMERSION. Retrieved January 6, 2022, from https://www.redcross.ca/crc/documents/Training-and-Certification/Swimming-and-Water-Safety-Tips-and-Resources/CRC-Immersions-Report-2020_EN.pdf  


Centers for Disease Control and Prevention. (2021, June 17). Drowning facts. Centers for Disease Control and Prevention. Retrieved January 6, 2022, from https://www.cdc.gov/drowning/facts/index.html  


Public Health Agency of Canada. (2021, December 20). Drowning related deaths and injuries. National Drowning Prevention Week - Data Blog - Chronic Disease Infobase | Public Health Agency of Canada. Retrieved January 6, 2022, from https://health-infobase.canada.ca/datalab/drowning-blog.html  


Lifesaving Society, & Drowning Prevention Research Centre. (2020). Drowning Report, National | 2020 Edition. Drowning Report. Retrieved January 6, 2022, from https://www.lifesaving.ca/cmsUploads/lifesaving/File/Lifesaving_Drowning-2020_CAN_En_2020.pdf 


Lifesaving Society Alberta and Northwest Territories Branch, & Drowning Prevention Research Centre. (2020). Drowning Report, Alberta | 2020 Edition. Drowning Report. Retrieved January 6, 2022, from https://www.lifesaving.org/public/download/files/133284 
Lifesaving Society Alberta and Northwest Territories Branch, & Injury Prevention Centre. (2021). Alberta Drowning Analysis. Alberta Drowning Analysis for 20 years. Retrieved January 6, 2022, from https://www.lifesaving.org/public/download/files/190301  

































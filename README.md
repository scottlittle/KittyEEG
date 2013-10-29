KittyEEG
========

Scott Little, 2013,
GNU GPL v3

MindSet EEG on Processing for Android using the Ketai library


I am using the NeuroSky MindSet EEG headset and Processing IDE with the Ketai library. I could not get the NeuroSky Android API to work with either of my Android 2.3.4 or 4.0.1 phones. When digging into why it didn't work, I got lost in their API's library and decided it would probably just be easier to read the data myself. I modified the Ketai bluetooth program to read in the raw data, but did it in sort of a haphazard way (no checksum was performed). It's quite a rough hack, but I got the data to draw on the screen and have not worked on it for a couple of weeks.

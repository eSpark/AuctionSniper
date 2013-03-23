AuctionSniper
=============

The Auction Sniper from _Growing Object Oriented Software, Guided by Tests_ but for iOS

Current Status:
---------------

Failing the first test.


Building
========

This is a bit of a chore to set up.  Here is what you will need to do:

Install [openfire](http://www.igniterealtime.org/projects/openfire/)

Create the following accounts:
* sniper/sniper
* auction-item-54321/auction
* auction-item-65432/auction

In the administration console, set the host to "localhost"
Set the Resource Policy to "never kick"

Openfire installs a preference item which lets you start/stop it.  It runs in 
32 bit mode so you have to restart System Preferences each time you access it.  
That's awesome.

run "bundle install"
Run the command "frank build" to compile the app, and make a "frankified" version 
of it, and install the build on the simulator.  Basically, this adds instrumentation
to the app that frank uses to "drive" the app on the simulator.

You might have to run some other commands, but I think that they have already
been run and committed to the project.  see [frank](http://testingwithfrank.com) 
for details.

To test, cd to the Frank directory (you will see ./features), and run cucumber.

g9.2-control
============

Mac OS X software to manage patches and control the Zoom G9.2tt guitar effects console.

Project Background
------------------

The G9.2 Control project was started in 2013 by Simon Biickert. The Mac software that [Zoom provides](http://www.zoom.co.jp/downloads/g92tt/software/) for the Zoom G9.2tt Guitar Effects console (G9.2tt Editor Librarian for Macintosh) has not been updated since September 2006. The librarian software shows real promise but is terminally difficult to operate due to a horrible user interface. This project is meant to create an alternate software product which does many of the same functions as the supplied software, but in a package with a superior user experience.

While in 2014, the logical platform for controlling the G9.2tt console might be an iPad, the Mac was chosen due to its robustness as a computing platform (and due to the fact that Simon had a USB-Midi cable available. The eventual goal will be to extend this project to the iOS platform.

Current Status
--------------

The project is being worked on on a part-time basis. The major tasks of development are:

1. Reverse-engineer the G9.2tt data model.
2. Create a Core Data document model which can store a G9.2tt patch set (100 patches).
3. Create a user interface allowing the user to manipulate the G9.2tt patch set.
4. Reverse-engineer the Midi communications between the existing Librarian software and the effects console.
5. Create a Midi control mode for the software which can send patch sets to the guitar console.
6. Create a Midi control mode for the software which sends control changes "live" to and from the guitar console.

Currently, development work is largely complete on step 3. The user interface uses standard Cocoa controls instead of simulating the look of real-world hardware as most guitar effects software does. This is one part for simplicity and another part that there are no digital artists working on the project.

Help
----

Simon welcomes assistance, even though it's unlikely that there are any Mac developers out there who are fans of the Zoom G9.2tt guitar effects console.
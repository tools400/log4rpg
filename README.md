# Log4rpg - A powerful logging service for RPG on IBM i

## Description

Debugging an application can be a very time consuming task. In particular this is true for applications that are made of small and smallest procedures and when the programmer does not exactly know where the error happens. For every procedure he has to decide whether to step over or step into it. Lots of debugging minutes can get lost because of a little mistake due to low concentration.

Inserting log statements into the code can ease the programmer’s life. The log reflects the program flow and lets the programmer know what happens. Hence it often is easier to locate the area where the bug sits.
That is what Log4rpg is made for. Log4rpg is a powerful logger that was inspired by the great LOG4J for Java. Like LOG4J it supports:

•	A logger hierarchy

•	Pluggable appenders

•	Pluggable Layouts

With Log4rpg it is possible to enable and disable logging just by modifying a configuration file. There is no need for changing code and compiling the program.

## Installation

Installing Log4rpg is a bit uncomfortable, because I could not yet migrate all my projects from Sourceforge to GitHub. Basically there are two options:

* Cloning (Git, GitHub) or checking out (SVN, Sourceforge) the projects and importing them to RDi as i Projects.
* Downloading the XML packages and running the installation utility.

This document focuses on the XML packages and the installer, because it seems as if still a lot of people are not familiar with SVN and Git.

### Prerequisites

The Log4rpg requires two additional service programs:

* [BASICS1](https://sourceforge.net/p/tools400/code/HEAD/tree/rpg-srvpgm/BASICS1/trunk/QXML/)
* [IFS](https://sourceforge.net/p/tools400/code/HEAD/tree/rpg-srvpgm/BASICS1/trunk/QXML/)

Both service programs are hosted on Sourceforge.

### Installation

Start with downloading the XML packages to your PC. Click the link, open the member and click the download link or button:

* [BASICS1](https://sourceforge.net/p/tools400/code/HEAD/tree/rpg-srvpgm/BASICS1/trunk/QXML/)
* [IFS](https://sourceforge.net/p/tools400/code/HEAD/tree/rpg-srvpgm/BASICS1/trunk/QXML/)
* [LOG4RPG](https://github.com/tools400/log4rpg/tree/master/Log4rpg/QXML)

Then logon to your IBM i system and follow these steps:

* Create a library `LOG4RPG`:

  `CRTLIB LIB(LOG4RPG) TEXT('Tools/400 Log4rpg Utility')`

* Create a source physical file with CCSID 273 and record length 112:

  `CRTSRCPF FILE(LOG4RPG/QXML) RCDLEN(112) CCSID(273)`

* Upload the XML files.
* Open member IFS and copy everything between the following lines into a new RPGLE source member `INSTALLER`:
  * `/// START OF INSTALL PGM HERE`
  * `/// END   OF INSTALL PGM HERE`
 
  Actually all 3 XML packages contain the same installer. The problem is that you cannot open BASICS1 and LOG4RPG with SEU, because both packages exceeds 32764 records. However you can use RDi or a PC text editor for extracting the installer program.

* Compile the installation utility:

  `CRTBNDRPG PGM(QTEMP/INSTALLER) SRCFILE(LOG4RPG/QXML) DFTACTGRP(*NO) ACTGRP(*NEW)`

* Run the following commands and answer the questions with one of the displayed options:

  `CALL PGM(QTEMP/INSTALLER) PARM(('BASICS1') ('QXML') ('LOG4RPG'))` 

  `CALL PGM(QTEMP/INSTALLER) PARM(('IFS') ('QXML') ('LOG4RPG'))` 

  `CALL PGM(QTEMP/INSTALLER) PARM(('LOG4RPG') ('QXML') ('LOG4RPG'))` 

  The questions asked by BASICS1 are:

    * _Create sample programs? (YES, NO)_ - typically you would answer `NO`
    * _C-Compiler available? (C_YES, C_NO)_ - if in doubt, try `C_YES` first

  The questions asked by IFS are:

   * _Select language (GER, ENG)_ - answer it with your preferred language
   * _Use *LIBL at runtime? (L_YES, L_NO)_ - answer it with `L_NO` if you do not want to use `*LIBL` for resolving service program BASICS1 at runtime

   The questions asked by LOG4RPG are:

   * _Use *LIBL at runtime? (L_YES, L_NO)_ - answer it with `L_NO` if you do not want to use `*LIBL` for resolving service program BASICS1 at runtime
   * _Create sample programs? (YES, NO)_ - typically you would answer `NO`

   **Hint: The answers are case-insensitive.**
 
---

© 2025, Thomas Raddatz

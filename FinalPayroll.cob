      *      James Olsen
      *      This program will sort two separate files and use file matching to match timecards
      *      with employee info. It will then calculate the weekly payroll by employee and the 
      *      total for all employees as well as total hours per day by employee.
      
       Identification Division.
       Program-Id.  Lab10a.
       
       Environment Division.
       Input-Output Section.
       File-Control.
            Select unsortedInput assign to "lab10a-in.dat" 
            organization is line sequential.
            
            Select tempInput assign to disk.
            
            Select sortedInput assign to "lab10a-insorted.dat"
            organization is line sequential.
            
            Select unsortedTimecard assign to "lab10a-timecard.dat"
            organization is line sequential.
            
            Select tempTimecard assign to disk.
            
            Select sortedTimecard assign to 
            "lab10a-sortedtimecard.dat"
            organization is line sequential.
            
            Select payroll assign to "lab10a-out.dat"
            organization is line sequential.
            
       
       Data Division.
       File Section.
       FD   unsortedInput.
       01   uInFileRec.
            05  uregionNum   Pic X(2).
            05  uregionName  Pic X(15).
            05  udeptNum     Pic X(5).
            05  udeptName    Pic X(30).
            05  uempNum      Pic X(5).
            05  ulastName    Pic X(20).
            05  ufirstName   Pic X(15).
            05  ugender      Pic X(1).
            05  ustreet      Pic X(20).
            05  ucityState   Pic X(20).
            05  ujobTitle    Pic X(20).
            05  udobYr       Pic 9(4).
            05  udobMo       Pic 99.
            05  udobDay      Pic 99.
            05  uhireYr      Pic 9(4).
            05  uhireMo      Pic 99.
            05  uhireDay     Pic 99.
            05  umaritalStat Pic X.
            05  unumDep      Pic 99.
            05  uschoolDist  Pic X(3).
            05  umedical     Pic X.
            05  udental      Pic X.
            05  uvision      Pic X.
            05  u401k        Pic V999.
            05  upayCode     Pic X.
            05  upay         Pic 9(7)V99.
            05  uhours       Pic 99V99.
            05  ucommission  Pic V9(3).
            05  usales       Pic 9(7)V99.
       SD   tempInput.
       01   tInFileRec.
            05  tregionNum   Pic X(2).
            05  tregionName  Pic X(15).
            05  tdeptNum     Pic X(5).
            05  tdeptName    Pic X(30).
            05  tempNum      Pic X(5).
            05  tlastName    Pic X(20).
            05  tfirstName   Pic X(15).
            05  tgender      Pic X(1).
            05  tstreet      Pic X(20).
            05  tcityState   Pic X(20).
            05  tjobTitle    Pic X(20).
            05  tdobYr       Pic 9(4).
            05  tdobMo       Pic 99.
            05  tdobDay      Pic 99.
            05  thireYr      Pic 9(4).
            05  thireMo      Pic 99.
            05  thireDay     Pic 99.
            05  tmaritalStat Pic X.
            05  tnumDep      Pic 99.
            05  tschoolDist  Pic X(3).
            05  tmedical     Pic X.
            05  tdental      Pic X.
            05  tvision      Pic X.
            05  t401k        Pic V999.
            05  tpayCode     Pic X.
            05  tpay         Pic 9(7)V99.
            05  thours       Pic 99V99.
            05  tcommission  Pic V9(3).
            05  tsales       Pic 9(7)V99.
       FD   unsortedTimecard.
       01   uTimecardRec.
            05  udNum    Pic X(5).
            05  ueNum    Pic X(5).
            05  uworkYear    Pic 9(4).
            05  uworkMonth   Pic 9(2).
            05  uworkDay Pic 9(2).
            05  utimeIn1Hr   Pic 9(2).
            05  utimeIn1Min  Pic 9(2).
            05  utimeOut1Hr  Pic 9(2).
            05  utimeOut1Min Pic 9(2).
            05  utimeIn2Hr   Pic 9(2).
            05  utimeIn2Min  Pic 9(2).
            05  utimeOut2Hr  Pic 9(2).
            05  utimeOut2Min Pic 9(2).
       SD   tempTimecard.
       01   ttimecardRec.
            05  tdNum    Pic X(5).
            05  teNum    Pic X(5).
            05  tworkYear    Pic 9(4).
            05  tworkMonth   Pic 9(2).
            05  tworkDay Pic 9(2).
            05  ttimeIn1Hr   Pic 9(2).
            05  ttimeIn1Min  Pic 9(2).
            05  ttimeOut1Hr  Pic 9(2).
            05  ttimeOut1Min Pic 9(2).
            05  ttimeIn2Hr   Pic 9(2).
            05  ttimeIn2Min  Pic 9(2).
            05  ttimeOut2Hr  Pic 9(2).
            05  ttimeOut2Min Pic 9(2).
       FD   sortedInput.
       01   inFileRec.
            05  regionNum   Pic X(2).
            05  regionName  Pic X(15).
            05  deptNum     Pic X(5).
            05  deptName    Pic X(30).
            05  empNum      Pic X(5).
            05  lastName    Pic X(20).
            05  firstName   Pic X(15).
            05  gender      Pic X(1).
            05  street      Pic X(20).
            05  cityState   Pic X(20).
            05  jobTitle    Pic X(20).
            05  dobYr       Pic 9(4).
            05  dobMo       Pic 99.
            05  dobDay      Pic 99.
            05  hireYr      Pic 9(4).
            05  hireMo      Pic 99.
            05  hireDay     Pic 99.
            05  maritalStat Pic X.
            05  numDep      Pic 99.
            05  schoolDist  Pic X(3).
            05  medical     Pic X.
            05  dental      Pic X.
            05  vision      Pic X.
            05  401k        Pic V999.
            05  payCode     Pic X.
            05  pay         Pic 9(7)V99.
            05  hours       Pic 99V99.
            05  commission  Pic V9(3).
            05  sales       Pic 9(7)V99.
       FD   sortedTimecard.
       01   timecardRec.
            05  dNum    Pic X(5).
            05  eNum    Pic X(5).
            05  workYear    Pic 9(4).
            05  workMonth   Pic 9(2).
            05  workDay Pic 9(2).
            05  timeIn1Hr   Pic 9(2).
            05  timeIn1Min  Pic 9(2).
            05  timeOut1Hr  Pic 9(2).
            05  timeOut1Min Pic 9(2).
            05  timeIn2Hr   Pic 9(2).
            05  timeIn2Min  Pic 9(2).
            05  timeOut2Hr  Pic 9(2).
            05  timeOut2Min Pic 9(2).
       FD   payroll.
       01   payrollRec  Pic X(145).
       Working-Storage Section.
       01   eof     Pic X Value "N".
       01   endOfFile   Pic X Value "N".
       01   wsDate.
            05  wsYr    Pic 9(4).
            05  wsMo    Pic 99.
            05  wsDay   Pic 99.
       01   wsTime.
            05  wsHr    Pic 99.
            05  wsMin   Pic 99.
            05  wsSec   Pic 99.
            05  wsCc    Pic 99.
       01   pageHeader.
            05  phMo  Pic Z9.
            05        Pic X Value "/".
            05  phDay Pic 99.
            05        Pic X Value "/".
            05  phYr  Pic 9(4).
            05        Pic X(47) Value spaces.
            05        Pic X(27) Value "Stomper & Wombat's Emporium".
            05        Pic X(52) value spaces.
            05        Pic X(6) value "Page: ".
            05  pageNum Pic ZZ9 value "1".
       01   pageSubHead.
            05          Pic XX value spaces.
            05  pgHr    Pic Z9.
            05          Pic X value ":".
            05  pgMin   Pic 99.
            05          Pic X value spaces.
            05  amPm    Pic X(2).
            05          Pic X(48) value spaces.
            05          Pic X(29) value "Weekly Hourly Payroll " &
                                  "Listing".
       01   blankLine   Pic X value spaces.
       01   detailHeader.
            05          Pic X value spaces.
            05          Pic X(5) value "Dep #".
            05          Pic X(3) value spaces.
            05          Pic X(5) value "Emp #".
            05          Pic X(10) value spaces.
            05          Pic X(8) value "Employee".
            05          Pic X(19) value spaces.
            05          Pic X(5) value "Title".
            05          Pic X(13) value spaces.
            05          Pic X(4) value "Date".
            05          Pic X(6) value spaces.
            05          Pic X(3) value "TIn".
            05          Pic X(3) value spaces.
            05          Pic X(4) value "TOut".
            05          Pic X(4) value spaces.
            05          Pic X(3) value "TIn".
            05          Pic X(3) value spaces.
            05          Pic X(4) value "TOut".
            05          Pic X(4) value spaces.
            05          Pic X(5) value "Hours".
       01   detailLine.
            05          Pic X value spaces.
            05  depNum  Pic X(5).
            05          Pic X(3) value spaces.
            05  emNum   Pic X(5).
            05          Pic X(4) value spaces.
            05  eLastName   Pic X(20).
            05          Pic X value spaces.
            05  eFirstName  Pic X.
            05          Pic X(4) value spaces.
            05  titleStr Pic X(20).
            05          Pic X(2) value spaces.
            05  dlMo    Pic Z9.
            05          Pic X value "/".
            05  dlDay   Pic 99.
            05          Pic X value "/".
            05  dlYr    Pic 9(4).
            05          Pic X(2) value spaces.
            05  tIn1Hr    Pic Z9.
            05            Pic X value ":".
            05  tIn1Min   Pic 99.
            05            Pic X(2) value spaces.
            05  tOut1Hr   Pic XX.
            05  colon1  Pic X.
            05  tOut1Min    Pic XX.
            05          Pic X(2) value spaces.
            05  tIn2Hr  Pic XX.
            05  colon2  Pic X.
            05  tIn2Min Pic XX.
            05          Pic X(2) value spaces.
            05  tOut2Hr Pic XX.
            05  colon3  Pic X.
            05  tOut2Min Pic 99.
            05          Pic X(3) value spaces.
            05  hoursHr   Pic XX.
            05            Pic X value ".".
            05  hoursMin  Pic 99.
       01   empTotal.
            05              Pic X(88) value spaces.
            05              Pic X(9) value "Employee ".
            05  empTotNum   Pic X(5).
            05              Pic X(4) value ":   ".
            05  empTotHours Pic ZZ9.99.
            05              Pic X(20) value " Hours; Gross Pay:  ".
            05  empTotPay  Pic $,$$$,$$9.99. 
       01   totalLine.
            05              Pic X(112) value spaces.
            05              Pic X(18) value "Total Gross Pay:  ".
            05   totalPay   Pic $$$,$$$,$$9.99.
       01   currentHours  Pic 99V99.
       01   currentMins   Pic 99V99.
       01   totalPayroll  Pic 9(9)V99.
       01   eTotalHrs   Pic 9(3)V99.
       01   eTotalMins  Pic 9(3)V99.
       01   eTotalPay   Pic 9(7)V99.
       01   counter     Pic 99.
       01   hoursH      Pic Z9.
       01   tIn1H       Pic Z9.
       01   tOut1H      Pic Z9.
       01   tIn2H       Pic Z9.
       01   tOut2H      Pic Z9.
       01   pastENum    Pic X(5).
       01   errorStr    Pic X.
       01   missing2    Pic X.
       01   overtime    pic 999V99.
       01   pastPay     pic 9(7)V99.
       01   currentDayHrs   pic 99V99.
       01   currentDayMins  pic 99V99.
       
       Procedure Division.
       000-main.
            perform 050-sortFiles
            open input sortedInput
                 input sortedTimecard
                 output payroll
            perform 110-getDate
            perform 120-getTime
            write payrollRec from pageHeader
                after advancing page
            write payrollRec from pageSubHead
                after advancing 1 line
            write payrollRec from blankLine
                after advancing 1 line
            write payrollRec from detailHeader
                after advancing 1 line
            write payrollRec from blankLine
                after advancing 1 line
            
            perform until eof = "Y"
                read sortedTimecard
                    at end
                        move "Y" to eof
                    not at end
                        move 0 to hoursH
                        move hoursH to hoursHr
                        
                        if not(eNum = pastENum)
                            perform 100-readInput
                            add 1 to counter
                            perform 130-newEmployee
                        else
                            move spaces to depNum emNum eLastName
                            eFirstName titleStr
                        end-if
                        
                        if eNum = empNum
                            move workMonth to dlMo
                            move workDay to dlDay
                            move workYear to dlYr
                            perform 140-checkDetail
                            perform 150-checkError
                            
                            if not (errorStr = "Y")
                                perform 190-calcDayHours
                                perform 200-calcDayMins
                                perform 160-calcHours
                                perform 170-calcMins
                                add currentHours to eTotalHrs
                                move eTotalHrs to empTotHours
                                move currentDayHrs to hoursH
                                move hoursH to hoursHr
                                move currentDayMins to hoursMin
                                move 0 to currentDayHrs currentDayMins
                            end-if
                            
                            move "N" to errorStr
                            move "N" to missing2
                            write payrollRec from detailLine
                                after advancing 1 line
                        end-if
                        
                        move eNum to pastENum
                        move pay to pastPay
                end-read
            end-perform
            
            move totalPayroll to totalPay
            write payrollRec from totalLine
                after advancing 1 line
            close sortedInput sortedTimecard payroll
            stop run.
            
       050-sortFiles.
            sort tempInput
                on ascending key tempNum
                using unsortedInput
                giving sortedInput
                
            sort tempTimecard
                on ascending key teNum
                using unsortedTimecard
                giving sortedTimecard.
                
       100-readInput.
            perform until eNum = empNum or endOfFile = "Y"
                read sortedInput
                    at end
                        move "Y" to endOfFile
                    not at end
                        continue
                end-read
            end-perform.
                    
       110-getDate.
            accept wsDate from date yyyymmdd
            move wsYr to phYr
            move wsMo to phMo
            move wsDay to phDay.
            
       120-getTime.
            accept wsTime from time
            move wsMin to pgMin
            
            if wsHr - 12 > 0
                subtract 12 from wsHr
                move wsHr to pgHr
                move "PM" to amPm
            else if wsHr - 12 = 0
                move wsHr to pgHr
                move "PM" to amPm
            else
                move wsHr to pgHr
                move "AM" to amPm
            end-if.
            
       130-newEmployee.
            move pastENum to empTotNum
            
            if counter>1
                perform 180-calcTotal
                move eTotalPay to empTotPay
                write payrollRec from blankLine
                    after advancing 1 line
                write payrollRec from empTotal
                    after advancing 1 line
                write payrollRec from blankLine
                    after advancing 1 line
            end-if
            
            move deptNum to depNum
            move empNum to emNum
            move lastName to eLastName
            move firstName to eFirstName
            move jobTitle to titleStr
            add eTotalPay to totalPayroll
            move 0 to eTotalPay eTotalHrs.
            
       140-checkDetail.
            if timeIn2Hr = "  " and timeOut2Hr = "  "
                move "Y" to missing2
                move timeIn1Hr to tIn1H
                move tIn1H to tIn1Hr
                move timeIn1Min to tIn1Min
                move timeOut1Hr to tOut2H
                move tOut2H to tOut2Hr
                move timeOut1Min to tOut2Min
                move "  " to tOut1Hr tOut1Min tIn2Hr tIn2Min
                move " " to colon1 colon2
                move ":" to colon3
            else if timeOut2Hr = "  " and not(timeIn2Hr = "  ")
                move timeIn1Hr to tIn1H
                move tIn1H to tIn1Hr
                move timeIn1Min to tIn1Min
                move timeOut1Hr to tOut1H
                move tOut1H to tOut1Hr
                move timeOut1Min to tOut1Min
                move timeIn2Hr to tIn2H
                move tIn2H to tIn2Hr
                move timeIn2Min to tIn2Min
                move "  " to tOut2Hr tOut2Min
                move " " to colon3
                move "**" to hoursHr
                move "Y" to errorStr
                move ":" to colon1 colon2
            else 
                move timeIn1Hr to tIn1H
                move tIn1H to tIn1Hr
                move timeIn1Min to tIn1Min
                move timeOut1Hr to tOut1H
                move tOut1H to tOut1Hr
                move timeOut1Min to tOut1Min
                move timeIn2Hr to tIn2H
                move tIn2H to tIn2Hr
                move timeIn2Min to tIn2Min
                move timeOut2Hr to tOut2H
                move tOut2H to tOut2Hr
                move timeOut2Min to tOut2Min
                move ":" to colon1 colon2 colon3
            end-if.
       
       150-checkError.
            if timeOut1Hr<timeIn1Hr and not(timeOut1Hr = "  ")
                move "**" to hoursHr
                move "Y" to errorStr
            else if timeIn2Hr<timeIn1Hr and not(timeIn2Hr = "  ")
                move "**" to hoursHr
                move "Y" to errorStr
            else if timeIn2Hr<timeOut1Hr and not (timeIn2Hr = "  ")
                move "**" to hoursHr
                move "Y" to errorStr
            end-if.
       
       160-calcHours.
            if missing2 = "Y"
                compute currentHours = timeOut1Hr - timeIn1Hr
            else 
                compute currentHours = timeOut1Hr - timeIn1Hr + 
                timeOut2Hr - timeIn2Hr
            end-if.
                        
       170-calcMins.
            if missing2 = "Y"
                compute currentMins = timeOut1Min - timeIn1Min
                compute currentMins = currentMins/60
                compute currentHours = currentHours + currentMins
            else
                compute currentMins = timeOut1Min - timeIn1Min + 
                timeOut2Min - timeIn2Min
                compute currentMins = currentMins/60
                compute currentHours = currentHours + currentMins
            end-if
            
            if currentMins<0
                compute currentMins = currentMins + 1
            end-if.
            
       180-calcTotal.
            if eTotalHrs > 40
                compute overtime = pastPay * 1.5
                compute eTotalPay = overtime * (eTotalHrs - 40)
                compute eTotalPay = eTotalPay + pastPay * 40
            else
                compute eTotalPay = pastPay * eTotalHrs
            end-if.
            
       190-calcDayHours.
            if missing2 = "Y"
                compute currentDayHrs = timeOut1Hr - timeIn1Hr
            else 
                compute currentDayHrs = timeOut1Hr - timeIn1Hr + 
                timeOut2Hr - timeIn2Hr
            end-if.
       
       200-calcDayMins.
            if missing2 = "Y"
                compute currentDayMins = timeOut1Min - timeIn1Min
                compute currentDayMins = currentDayMins/60
                compute currentDayHrs = currentDayHrs + 
                currentDayMins
            else
                compute currentDayMins = timeOut1Min - timeIn1Min + 
                timeOut2Min - timeIn2Min
                compute currentDayMins = currentDayMins/60
                compute currentDayHrs = currentDayHrs + 
                currentDayMins
            end-if
            
            if currentDayMins<0
                compute currentDayMins = currentDayMins + 1
            end-if
            
            compute currentDayMins = currentDayMins * 100.
                
      *      James Olsen
      *      Given an input file in the Payroll format, provide an output file that displays key payroll info for the company.      
       
       Identification Division.
       Program-Id. Lab4.
       
       Environment Division.
       Input-Output Section.
       File-Control.
           Select PayrollFile
                Assign to "lab4-in.dat"
                Organization is line sequential.
           Select PayrollReport
                Assign to "payrollrpt-out.dat"
                Organization is line sequential.
                
       Data Division.
       File Section.
       FD PayrollFile.
       01  PayrollRec.
           05  RegionNum   Pic X(2).
           05  RegionName  Pic X(15).
           05  DeptNum     Pic X(5).
           05  DeptName    Pic X(30).
           05  EmpNum      Pic X(5).
           05  LastName    Pic X(20).
           05  FirstName   Pic X(15).
           05  Gender      Pic X(1).
           05  Street      Pic X(20).
           05  CityState   Pic X(20).
           05  JobTitle    Pic X(20).
           05  DOBYr       Pic 9(4).
           05  DOBMo       Pic 99.
           05  DOBDay      Pic 99.
           05  HireYr      Pic 9(4).
           05  HireMo      Pic 99.
           05  HireDay     Pic 99.
           05  MaritalStat Pic X.
           05  NumDep      Pic 99.
           05  SchoolDist  Pic X(3).
           05  Medical     Pic X.
           05  Dental      Pic X.
           05  Vision      Pic X.
           05  401k        Pic V999.
           05  PayCode     Pic X.
           05  Pay         Pic 9(7)V99.
           05  Hours       Pic 99V99.
           05  Commission  Pic V9(3).
           05  Sales       Pic 9(7)V99.
       FD  PayrollReport.
       01  ReportRecord     Pic X(141).
       
       Working-Storage Section.
       01   EOF         Pic X Value "N".
       01   RptFields.
            05  PageNo      Pic 9(3) Value 0.
            05  LinesPerPg  Pic 9(2) Value 35.
            05  LineNo      Pic 9(2) Value 99.
       01   WSDate.
            05  WSYr        Pic 9(4).
            05  WSMo        Pic 99.
            05  WSDay       Pic 99.
       01   WSTime.
            05  WSHr        Pic 99.
            05  WSMin       Pic 99.
            05  WSSec       Pic 99.
            05  WSCC        Pic 99.
       01   PageHeader.
            05  PHMo        Pic Z9.
            05              Pic X Value "/".
            05  PHDay       Pic 99.
            05              Pic X Value "/".
            05  PHYr        Pic 9(4).
            05              Pic X(44) Value spaces.
            05              Pic X(27) Value "Stomper & Wombat's " &
                                            "Emporium".
            05              Pic X(47) Value spaces.
            05              Pic X(6) Value "Page: ".
            05  PgNo        Pic ZZ9.
       01   PageSubHead.
            05              Pic XX Value spaces.
            05  PgHr        Pic Z9.
            05              Pic X Value ":".
            05  PgMin       Pic 99.
            05              Pic X Value spaces.
            05  AMPM        Pic XX.
            05              Pic X(45) Value spaces.
            05              Pic X(29) Value "Monthly Gross Payroll " &
                                            "Listing".
       01   ColumnHead.
            05              Pic X(6) Value " Dep #".
            05              Pic X(3) Value spaces.
            05              Pic X(5) Value "Emp #".
            05              Pic X(10) Value spaces.
            05              Pic X(8) Value "Employee".
            05              Pic X(19) Value spaces.
            05              Pic X(5) Value "Title".
            05              Pic X(13) Value spaces.
            05              Pic X(3) Value "DOH".
            05              Pic X(6) Values spaces.
            05              Pic X(7) Value "Marital".
            05              Pic X(2) Value spaces.
            05              Pic X(5) Value "#Deps".
            05              Pic X(2) Value spaces.
            05              Pic X(3) Value "Ins".
            05              Pic X(3) Value spaces.
            05              Pic X(4) Value "401k".
            05              Pic X(2) Value spaces.
            05              Pic X(3) Value "Pay".
            05              Pic X(3) Value spaces.
            05              Pic X(12) Value "Expected Pay".
            05              Pic X(2) Value spaces.
            05              Pic X Value "+".
            05              Pic X(2) Value spaces.
            05              Pic X(10) Value "Commission".
       01 DetailLine.
           05   DeptStr     Pic Z(5)9.
           05   EmpNoStr    Pic Z(7)9.
           05   EmpNameStr.
                10              Pic X(4) Value spaces.
                10  EmpLName    Pic X(20).
                10              Pic X Value spaces.
                10  EmpFName    Pic X.
           05   JobTitleStr.
                10              Pic X(4) Value spaces.
                10  TitleStr    Pic X(20).
                10              Pic X(2) Value spaces.
           05   DateHireStr.
                10  MoStr       Pic Z9.
                10              Pic X Value "/".
                10  DayStr      Pic 99.
                10              Pic X Value "/".
                10  YrStr       Pic 9(4).
                10              Pic X(5) Value spaces.
           05   MaritalStr.
                10  MStatStr    Pic X.
                10              Pic X(7) Value spaces.
           05   DependStr.
                10  NumDepStr   Pic Z9.
                10              Pic X(3) Value spaces.
           05   InsStr.
                10  MedStr      Pic X.
                10  DentStr     Pic X.
                10  VisStr      Pic X.
                10              Pic X(3) Value spaces.
           05   401kStr.
                10  401kAmt     Pic 9.99.
                10              Pic X Value "%".
                10              Pic X(2) Value spaces.
           05   PayStr.
                10  PayCodeStr  Pic X.
                10              Pic X(3) Value spaces.
           05   ExpPayStr.
                10  PayAmtStr   Pic $,$$$,$$9.99.
                10              Pic X(4) Value spaces.
           05   CommissionStr.
                10  ComAmt      Pic $,$$$,$$9.99
                        Blank when zero.
       01   TotalPayroll Pic 9(9)V99.
       01   TotalLine.
            05                Pic X(101) Value spaces.
            05                Pic X(24) Value "Total Expected " &
                                               "Payroll: ".
            05   TotalPayStr  Pic $$$,$$$,$$9.99.
       01   BlankLine   Pic X Value spaces.
       01   ExpPayAmt   Pic 9(7)V99.
       01   CommisAmt   Pic 9(7)V99.
       01   401kTemp    Pic 999V999.
       
       Procedure Division.
       000-Main.
           Open input PayrollFile
                output PayrollReport
           Perform 100-GetDate
           Perform 150-GetTime
           
           Perform until EOF="Y"
                Read PayrollFile
                    At end
                        Move "Y" to EOF
                    Not at end
                        Perform 200-Process
                        Perform 500-Print
                End-Read
           End-Perform        
            
           Perform 700-Final
           Close PayrollFile PayrollReport
           Stop Run.
       
       100-GetDate.
           Accept WSDate from date yyyymmdd
           Move WSYr to PHYr
           Move WSMo to PHMo
           Move WSDay to PHDay.
           
       150-GetTime.
            Accept WSTime from time
            Move WSMin to PgMin
            
            If WSHr - 12 > 0
                Subtract 12 from WSHr
                Move WSHr to PgHr
                Move "PM" to AMPM
            Else if WSHr - 12 = 0
                Move WSHr to PgHr
                Move "PM" to AMPM
            Else 
                Move WSHr to PgHr
                Move "AM" to AMPM
            End-if.
       
       200-Process.
            Move DeptNum to DeptStr
            Move EmpNum to EmpNoStr
            Move LastName to EmpLName
            Move FirstName to EmpFName
            Move JobTitle to TitleStr
            Move HireMo to MoStr
            Move HireDay to DayStr
            Move HireYr to YrStr
            Move MaritalStat to MStatStr
            Move NumDep to NumDepStr
            
            Perform 250-Insurance
            
            Move 401k to 401kTemp
            Compute 401kTemp = 401k * 100
            Move 401kTemp to 401kAmt
            Move PayCode to PayCodeStr
            
            Perform 300-CalculatePay
            
            Move ExpPayAmt to PayAmtStr
            
            Perform 400-DetermineCommission
            
            Compute TotalPayroll Rounded = TotalPayroll+CommisAmt+
            ExpPayAmt.
            
       250-Insurance.
           If Medical="Y"
                Move "M" to MedStr
           Else
                Move space to MedStr
           End-if
           
           If Dental="Y"
                Move "D" to DentStr
           Else
                Move space to DentStr
           End-if
           
           If Vision="Y"
                Move "V" to VisStr
           Else
                Move space to VisStr
           End-if.
           
       300-CalculatePay.
           If PayCode = "S" or "C"
                Compute ExpPayAmt Rounded = Pay/12
           Else
                Compute ExpPayAmt Rounded = Pay*Hours*(52/12)
           End-if.
                
       400-DetermineCommission.
           If PayCode = "C"
                Compute CommisAmt Rounded = Commission*45000
           Else
                Compute CommisAmt = 0
           End-if
           Move CommisAmt to ComAmt.
                
       500-Print.
           If LineNo >= LinesPerPg
                Perform 600-NewPage
           End-if
           
           Write ReportRecord from DetailLine
                After advancing 1 line
           Add 1 to LineNo.
           
       600-NewPage.
           If PageNo > 0
                Write ReportRecord from BlankLine
                    After advancing 1 line
           End-if
           
           Add 1 to PageNo
           Move PageNo to PgNo
           Write ReportRecord from PageHeader
                After advancing page
           Write ReportRecord from PageSubHead
                After advancing 1 line
           Write ReportRecord from BlankLine
                After advancing 1 line
           Write ReportRecord from ColumnHead
                After advancing 1 line
           Write ReportRecord from BlankLine
                After advancing 1 line
           Move 5 to LineNo.
       
       700-Final.
           If LineNo + 1 > LinesPerPg
                Perform 600-NewPage
           End-if
           
           Write ReportRecord from BlankLine
                After advancing 1 line
           Move TotalPayroll to TotalPayStr
           Write ReportRecord from TotalLine
                After advancing 1 line
           Add 2 to LineNo.
          
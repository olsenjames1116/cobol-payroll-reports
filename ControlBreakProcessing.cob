      *      James Olsen
      *      This program takes a payroll file as input and writes to an output file with the payroll
      *      separated and subtotaled by department.
       
       Identification Division.
       Program-Id. Lab6a.
       
       Environment Division.
       Input-Output Section.
       File-Control.
           Select PayrollFile
                Assign to "lab6a-in.dat"
                Organization is line sequential.
           Select PayrollReport
                Assign to "lab6a-out.dat"
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
            05              Pic X(49) Value spaces.
            05              Pic X(6) Value "Page: ".
            05  PgNo        Pic ZZ9.
       01   PageSubHead.
            05              Pic XX Value spaces.
            05  PgHr        Pic Z9.
            05              Pic X Value ":".
            05  PgMin       Pic 99.
            05              Pic X Value spaces.
            05  AMPM        Pic XX.
            05              Pic X(39) Value spaces.
            05              Pic X(43) Value "Monthly Payroll " &
                                            "Register - Salary and " &
                                            "Sales".
       01   DepartmentHead.
            05               Pic X(14) Value "  Department: ".
            05  DepartNumStr Pic X(5).
       01   DepartmentSubHead.
            05                Pic X(14) Value spaces.
            05  DepartNameStr Pic X(30).
       01   ColumnHead.
            05              Pic X(1) Value spaces.
            05              Pic X(5) Value "Emp #".
            05              Pic X(10) Value spaces.
            05              Pic X(8) Value "Employee".
            05              Pic X(8) Value spaces.
            05              Pic X(1) Value "M".
            05              Pic X(2) Value spaces.
            05              Pic X(4) Value "Deps".
            05              Pic X(2) Values spaces.
            05              Pic X(3) Value "Ins".
            05              Pic X(5) Value spaces.
            05              Pic X(9) Value "Gross Pay".
            05              Pic X(6) Value spaces.
            05              Pic X(10) Value "Commission".
            05              Pic X(7) Value spaces.
            05              Pic X(5) Value "401k".
            05              Pic X(10) Value spaces.
            05              Pic X(3) Value "Fed".
            05              Pic X(7) Value spaces.
            05              Pic X(5) Value "State".
            05              Pic X(5) Value spaces.
            05              Pic X(9) Value "Insurance".
            05              Pic X(6) Value spaces.
            05              Pic X(7) Value "Net Pay".
       01 DetailLine.
           05   EmpNoStr    Pic Z(5)9.
           05   EmpNameStr.
                10              Pic X(2) Value spaces.
                10  EmpLName    Pic X(20).
                10              Pic X Value spaces.
                10  EmpFName    Pic X.
           05   MaritalStr.
                10              Pic X(2) Value spaces.
                10  Married     Pic X.
           05   DependStr.
                10              Pic X(3) Value spaces.
                10  NumDepStr   Pic Z9.
           05   InsStr.
                10              Pic X(3) Value spaces.
                10  MedStr      Pic X.
                10  DentStr     Pic X.
                10  VisStr      Pic X.             
           05   ExpPayStr.
                10              Pic X(4) Value spaces.
                10  PayAmtStr   Pic $,$$$,$$9.99.
           05   CommissionStr.
                10              Pic X(4) Value spaces.
                10  ComAmt      Pic $,$$$,$$9.99
                                blank when zero.
           05   401kStr.
                10              Pic X(3) Value spaces.
                10  401kAmt     Pic $$,$$9.99.
           05   FedStr.
                10              Pic X(4) Value spaces.
                10  FedTaxStr   Pic $$,$$9.99.
           05   StateStr.
                10              Pic X(3) Value spaces.
                10  StateTaxStr Pic $$,$$9.99.
           05   InsAmtStr.
                10              Pic X(3) Value spaces.
                10  InsurAmtStr Pic $$,$$9.99.
           05   NetPayStr.
                10               Pic X(4) Value spaces.
                10  NetPayAmtStr Pic $,$$$,$$9.99.
       01   TotalPayroll Pic 9(9)V99.
       01   TotalDeptPayroll    Pic 9(9)V99.
       01   TotalDeptLine.
            05                Pic X(99) Value spaces.
            05                Pic X(5) Value "Dept ".
            05   DeptNumStr   Pic X(5).
            05                Pic X(18) Value " Total Payroll:   ".
            05   TotalPayStr  Pic $$$,$$$,$$9.99.
       01   TotalLine.
            05                Pic X(91) Value spaces.
            05                Pic X(36) Value "Total Payroll (Salary" &
                              " and Sales):   ".
            05  TotalStr      Pic $$$,$$$,$$9.99.
       01   BlankLine   Pic X Value spaces.
       01   ExpPayAmt   Pic 9(7)V99.
       01   CommisAmt   Pic 9(7)V99.
       01   401kTemp    Pic 9(5)V99.
       01   Fed         Pic 9(5)V99. 
       01   State       Pic 9(5)V99.
       01   MedCost     Pic 9(3).
       01   DentCost    Pic 9(2).
       01   VisionCost  Pic 9V99.
       01   TotalInsurance Pic 9(5)V99.
       01   CurrentDept Pic X(5).
       01   PastDept    Pic X(5) Value "     ".
       01   DeptCount   Pic 99.
       
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
                        Perform 775-Print
                End-Read
           End-Perform        
            
           Perform 850-Final
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
            Move EmpNum to EmpNoStr
            Move LastName to EmpLName
            Move FirstName to EmpFName
            Move MaritalStat to Married
            Move NumDep to NumDepStr
            Perform 250-Insurance
            Perform 300-CalculatePay
            Perform 400-DetermineCommission
            Move ExpPayAmt to PayAmtStr
            Perform 500-Compute401k
            Perform 550-ComputeFed
            Perform 600-ComputeState
            Perform 650-ComputeInsurance
            Perform 700-DisplayNetPay
            Perform 725-ControlDept
            Move DeptNum to PastDept.
            
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
                Compute CommisAmt Rounded = Commission*Sales
                Add CommisAmt to ExpPayAmt
                Move CommisAmt to ComAmt
           Else
                Move 0 to ComAmt
           End-if.
           
       500-Compute401k.
            If 401k = 0
                Move 0 to 401kAmt
            Else
                Compute 401kTemp Rounded = 401k*ExpPayAmt
                Move 401kTemp to 401kAmt
                Compute ExpPayAmt = ExpPayAmt - 401kTemp
            End-if.
           
       550-ComputeFed.
            If Married = "M" or "P"
                Compute Fed Rounded = .28*ExpPayAmt
                Compute ExpPayAmt = ExpPayAmt - Fed
                Move Fed to FedTaxStr
            Else
                Compute Fed Rounded = .33*ExpPayAmt
                Compute ExpPayAmt = ExpPayAmt - Fed
                Move Fed to FedTaxStr
            End-if.
            
       600-ComputeState.
            Compute State Rounded = 0.0475*ExpPayAmt
            Compute ExpPayAmt = ExpPayAmt - State
            Move State to StateTaxStr.
            
       650-ComputeInsurance.
            If NumDep >= 2
                If Medical = "Y"    
                    Move 100 to MedCost
                Else 
                    Move 0 to MedCost
                End-if
                Compute ExpPayAmt = ExpPayAmt - MedCost
                
                If Dental = "Y"
                    Move 40 to DentCost
                Else
                    Move 0 to DentCost
                End-if
                Compute ExpPayAmt = ExpPayAmt - DentCost
                
                If Vision = "Y"
                    Move 7.5 to VisionCost
                Else
                    Move 0 to VisionCost
                End-if
                Compute ExpPayAmt = ExpPayAmt - VisionCost   
            Else
                If Medical = "Y"    
                    Move 75 to MedCost
                Else 
                    Move 0 to MedCost
                End-if
                Compute ExpPayAmt = ExpPayAmt - MedCost
                
                If Dental = "Y"
                    Move 25 to DentCost
                Else
                    Move 0 to DentCost
                End-if
                Compute ExpPayAmt = ExpPayAmt - DentCost
                
                If Vision = "Y"
                    Move 5 to VisionCost
                Else
                    Move 0 to VisionCost
                End-if
                Compute ExpPayAmt = ExpPayAmt - VisionCost
            End-if
            
            Compute TotalInsurance = MedCost + DentCost + VisionCost
            Move TotalInsurance to InsurAmtStr.
            
       700-DisplayNetPay.
            Move ExpPayAmt to NetPayAmtStr.
            
       725-ControlDept.
            Move DeptNum to CurrentDept
           
            If Not (CurrentDept = PastDept)

                If Not (PastDept = Low-values)
                    Perform 825-PrintDeptTotal
                End-if

                Perform 750-NewDepartment
            End-if

            Compute TotalDeptPayroll = TotalDeptPayroll + ExpPayAmt
            Add 1 to DeptCount.
                
       750-NewDepartment.
            If LineNo + 5 > LinesPerPg
                Perform 800-NewPage
            End-if
            
                Move DeptNum to DepartNumStr
                Move DeptName to DepartNameStr
                Write ReportRecord from DepartmentHead
                    after advancing 1 line
                Write ReportRecord from DepartmentSubHead
                    after advancing 1 line
                Write ReportRecord from BlankLine
                    after advancing 1 line
                Write ReportRecord from ColumnHead
                    After advancing 1 line
                Write ReportRecord from BlankLine
                    after advancing 1 line
                Add 5 to LineNo.
            
       775-Print.
           If LineNo >= LinesPerPg
                Perform 800-NewPage
           End-if
           
           Write ReportRecord from DetailLine
                After advancing 1 line
           Add 1 to LineNo.
           
       800-NewPage.
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
                after advancing 1 line
           Move 3 to LineNo.
       
       825-PrintDeptTotal.
           If LineNo + 3 > LinesPerPg
                Perform 800-NewPage
           End-if

           If DeptCount > 1
               Write ReportRecord from BlankLine
                    After advancing 1 line
               Move PastDept to DeptNumStr
               Move TotalDeptPayroll to TotalPayStr
               Write ReportRecord from TotalDeptLine
                    After advancing 1 line
               Write ReportRecord from BlankLine
                    after advancing 1 line
               Add 3 to LineNo
            End-if
            
            Add TotalDeptPayroll to TotalPayroll
            Move 0 to TotalDeptPayroll.

       850-Final.
            If LineNo + 1 > LinesPerPg
                Perform 800-NewPage
            End-if
            
            Perform 825-PrintDeptTotal

            If LineNo + 2 > LinesPerPg
                Perform 800-NewPage
            End-if
            
            Move TotalPayroll to TotalStr
            Write ReportRecord from TotalLine
                after advancing 1 line
            Add 1 to LineNo.

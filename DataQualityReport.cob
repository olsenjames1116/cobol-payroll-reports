      *      James Olsen
      *      Takes a payroll input file and returns errors that are within the file as well as counts of the amount of errors and records with errors.    
       
       Identification Division.
       Program-Id. Lab5.
       
       Environment Division.
       Configuration Section.
       Special-Names.
            Class Num is "0" thru "9".
       Input-Output Section.
       File-Control.
           Select PayrollFile
                Assign to "lab5-in.dat"
                Organization is line sequential.
           Select PayrollErrors
                Assign to "lab5-out.dat"
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
           05  HireDate.
               10  HireYr      Pic 9(4).
               10  HireMo      Pic 99.
               10  HireDay     Pic 99.
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
       FD  PayrollErrors.
       01  ReportRecord             Pic X(203).
       Working-Storage Section.
       01   EOF                     Pic X.
       01   DetailLine.
           05  DeptNumStr     Pic X(5).
           05  DeptNameStr    Pic X(30).
           05  EmpNumStr      Pic X(5).
           05  LastNameStr    Pic X(20).
           05  FirstNameStr   Pic X(15).
           05  GenderStr      Pic X(1).
           05  StreetStr      Pic X(20).
           05  CityStateStr   Pic X(20).
           05  JobTitleStr    Pic X(20).
           05  DOBYrStr       Pic 9(4).
           05  DOBMoStr       Pic 99.
           05  DOBDayStr      Pic 99.
           05  HireDateStr.
               10  HireYrStr      Pic X(4).
               10  HireMoStr      Pic X(2).
               10  HireDayStr     Pic X(2).
           05  MaritalStatStr Pic X.
           05  NumDepStr      Pic 99.
           05  SchoolDistStr  Pic X(3).
           05  MedicalStr     Pic X.
           05  DentalStr      Pic X.
           05  VisionStr      Pic X.
           05  401kStr        Pic V9(3).
           05  PayCodeStr     Pic X.
           05  PayStr         Pic 9(7)V99.
           05  HoursStr       Pic 99V99.
           05  CommissionStr  Pic V9(3).
           05  SalesStr       Pic 9(7)V99.
       01   HireDates               Pic 9(8).
       01   EmpNumError             Pic X.
       01   DeptError               Pic X.
       01   GenderError             Pic X.
       01   MaritalError            Pic X.
       01   PayCodeError            Pic X.
       01   HoursError              Pic X.
       01   HoursSignError          Pic X.
       01   ExcessiveHoursError     Pic X.
       01   PayError                Pic X.
       01   PaySignError            Pic X.
       01   DateNumError            Pic X.
       01   DateValidError          Pic X.
       01   FutureDateError         Pic X.
       01   AgeError                Pic X.
       01   SchoolError             Pic X.
       01   ErrorCount              Pic 9(4).
       01   RecordErrorCount        Pic 9(4).
       01   ThisIncidentCount       Pic 9(2).
       01   WSDate.
            05  WSYr           Pic 9(4).
            05  WSMo           Pic 9(2).
            05  WSDay          Pic 9(2).
       01   FirstChar               Pic X.
       01   SecondChar              Pic X.
       01   ThirdChar               Pic X.
       01   TotalErrorLine.
            05                 Pic X(30) Value "Total errors:".
            05  TotalErrors    Pic ZZZ9.
       01   TotalRecordErrorLine.
            05                 Pic X(30) Value "Total records with " &
                                               "errors:".
            05  TotalRecordErrors   Pic ZZZ9.
       01   BlankLine               Pic X Value spaces.
       01   PrintEmpError       Pic X(203) Value "Non-numeric" &
                " employee number found on the following record:".
       01   PrintDeptError      Pic X(203) Value "Non-alphabetic " &
                    "department name found on the following record:".
       01   PrintGenderError    Pic X(203) Value "Invalid gender " &
                              "code found on the following record:".
       01   PrintMaritalError   Pic X(203) Value "Invalid marital " & 
                             "status found on the following record:".
       01   PrintPayCodeError   Pic X(203) Value "Invalid pay code " &
                                "found on the following record:".
       01   PrintHoursError     Pic X(203) Value "Non-numeric hours " & 
                             "per week found on the following record:".
       01   PrintHoursSignError Pic X(203) Value "Negative hours " &
                             "per week found on the following record:".
       01   PrintExcessiveHrs   Pic X(203) Value "Excessive hours " &
                             "per week found on the following record:".
       01   PrintPayError       Pic X(203) Value "Non-numeric pay " &
                            "rate found on the following record:".
       01   PrintPaySignError   Pic X(203) Value "Negative pay rate " &
                                "found on the following record:". 
       01   PrintDateNumError   Pic X(203) Value "Non-numeric hire " &
                                "date found on the following record:".
       01   PrintDateValError   Pic X(203) Value "Invalid hire date " &
                                "found on the following record:".
       01   PrintFutureError    Pic X(203) Value "Future hire date " &
                                "found on the following record:".
       01   PrintAgeError       Pic X(203) Value "Invalid age for " &
                               "hire found on the following record:".
       01   PrintSchoolError    Pic X(203) Value "Invalid school " &
                      "district format found on the following record:".
                
       
       Procedure Division.
       000-Main.
           Open input PayrollFile
                output PayrollErrors
                
           Perform until EOF="Y"
                Read PayrollFile
                    At end
                        Move "Y" to EOF
                    Not at end
                        Perform 100-Process
                        
                        If ThisIncidentCount > 0
                            Add 1 to RecordErrorCount
                            Perform 500-PrintErrors
                            Perform 600-MoveRecords
                            Write ReportRecord from DetailLine
                                after advancing 1 line
                            Write ReportRecord from BlankLine
                                after advancing 1 line
                        End-if
                        
                        Perform 700-ResetValues
                End-Read
           End-Perform
           
           Move ErrorCount to TotalErrors
           Move RecordErrorCount to TotalRecordErrors
           Write ReportRecord from TotalErrorLine
                after advancing 1 line
           Write ReportRecord from TotalRecordErrorLine
                after advancing 1 line
           Close PayrollFile PayrollErrors
           Stop Run.
           
       100-Process.
            Perform 125-CheckEmpNum
            Perform 150-CheckDepartment
            Perform 175-CheckGender
            Perform 200-CheckMarital
            Perform 225-CheckPayCode
            Perform 250-CheckHours
            Perform 275-CheckHoursSign
            Perform 300-CheckExcessiveHours
            Perform 325-CheckPayRate
            Perform 350-CheckPaySign
            Perform 375-CheckDateNum
            Perform 400-CheckValidDate
            Perform 425-CheckFutureDate
            If Not (DateValidError = "Y")
                Perform 450-CheckAge
            End-if
            Perform 475-CheckSchool.
       
       125-CheckEmpNum.
            If EmpNum is not numeric
                Move "Y" to EmpNumError
                Add 1 to ThisIncidentCount
                Add 1 to ErrorCount
            End-if.
            
       150-CheckDepartment.
            If DeptName is not alphabetic
                Move "Y" to DeptError
                Add 1 to ThisIncidentCount
                Add 1 to ErrorCount
            End-if.
            
       175-CheckGender.
            If Not (Gender = "M" or "F" or "R" or "U")
                Move "Y" to GenderError
                Add 1 to ThisIncidentCount
                Add 1 to ErrorCount
            End-if.
       
       200-CheckMarital.
            If Not (MaritalStat = "D" or "M" or "P" or "S" or "W")
                Move "Y" to MaritalError
                Add 1 to ThisIncidentCount
                Add 1 to ErrorCount
            End-if.
       
       225-CheckPayCode.
            If Not (PayCode = "C" or "S" or "H")
                Move "Y" to PayCodeError
                Add 1 to ThisIncidentCount
                Add 1 to ErrorCount
            End-if.
       
       250-CheckHours.
            If Hours is not numeric 
                Move "Y" to HoursError
                Add 1 to ThisIncidentCount
                Add 1 to ErrorCount
            End-if.
       
       275-CheckHoursSign.
            If Hours is numeric
                If Hours is negative
                    Move "Y" to HoursSignError
                    Add 1 to ThisIncidentCount
                    Add 1 to ErrorCount
                End-if
            End-if.
            
       300-CheckExcessiveHours.
            If Hours is numeric
                If Hours > 60
                    Move "Y" to ExcessiveHoursError
                    Add 1 to ThisIncidentCount
                    Add 1 to ErrorCount
                End-if
            End-if.
       
       325-CheckPayRate.
            If Pay is not Num
                Move "Y" to PayError
                Add 1 to ThisIncidentCount
                Add 1 to ErrorCount
            End-if.
            
       350-CheckPaySign.
            If Pay is numeric
                If Pay is negative
                    Move "Y" to PaySignError
                    Add 1 to ThisIncidentCount
                    Add 1 to ErrorCount
                End-if
            End-if.
            
       375-CheckDateNum.
            If HireYr is not numeric
                Move "Y" to DateNumError
                Add 1 to ThisIncidentCount
                Add 1 to ErrorCount
                Exit paragraph
            End-if
            
            If HireMo is not numeric
                Move "Y" to DateNumError
                Add 1 to ThisIncidentCount
                Add 1 to ErrorCount
                Exit paragraph
            End-if
            
            If HireDay is not numeric
                Move "Y" to DateNumError
                Add 1 to ThisIncidentCount
                Add 1 to ErrorCount
            End-if.
       
       400-CheckValidDate.
            If HireDate is numeric
               Move HireDate to HireDates
                If Function test-date-yyyymmdd(HireDates)>0
                    Move "Y" to DateValidError
                    Add 1 to ThisIncidentCount
                    Add 1 to ErrorCount
                    Exit paragraph
                End-if
            End-if.
                    
       425-CheckFutureDate.
            Accept WSDate from date yyyymmdd
            
            If HireDate is numeric
                If HireYr > WSYr
                    Move "Y" to FutureDateError
                    Add 1 to ThisIncidentCount
                    Add 1 to ErrorCount
                    Exit paragraph
                Else if HireYr = WSYr
                    If HireMo > WSMo
                        Move "Y" to FutureDateError
                        Add 1 to ThisIncidentCount
                        Add 1 to ErrorCount
                        Exit paragraph
                    Else if HireMo = WSMo
                        If HireDay > WSDay
                            Move "Y" to FutureDateError
                            Add 1 to ThisIncidentCount
                            Add 1 to ErrorCount
                        End-if
                    End-if
                End-if
            End-if.
            
       450-CheckAge.
            If HireDate is numeric
                If HireYr - DOBYr < 18
                    Move "Y" to AgeError
                    Add 1 to ThisIncidentCount
                    Add 1 to ErrorCount
                    Exit paragraph
                Else if HireYr - DOBYr = 18
                    If HireMo < DOBMo
                        Move "Y" to AgeError
                        Add 1 to ThisIncidentCount
                        Add 1 to ErrorCount
                        Exit paragraph
                    Else if HireMo = DOBMo
                        If HireDay < DOBDay
                            Move "Y" to AgeError
                            Add 1 to ThisIncidentCount
                            Add 1 to ErrorCount
                        End-if
                    End-if
                End-if
            End-if.
       
       475-CheckSchool.       
            Unstring SchoolDist(1:1)
                    Into FirstChar
            End-unstring
            Unstring SchoolDist(2:1)
                    Into SecondChar
            End-unstring
            Unstring SchoolDist(3:1)
                    Into ThirdChar
            End-unstring
            
            If FirstChar is numeric and SecondChar is numeric
                If FirstChar = SecondChar
                    If ThirdChar is numeric
                        Move "Y" to SchoolError
                        Add 1 to ThisIncidentCount
                        Add 1 to ErrorCount
                        Exit paragraph
                    End-if
                Else if Function MOD(FirstChar,2)=0 and 
                Function MOD(SecondChar,2)=0 
                    Move "Y" to SchoolError
                    Add 1 to ThisIncidentCount
                    Add 1 to ErrorCount
                    Exit paragraph
                Else if Function MOD(FirstChar,2)=1 and 
                Function MOD(SecondChar,2)=1
                    Move "Y" to SchoolError
                    Add 1 to ThisIncidentCount
                    Add 1 to ErrorCount
                    Exit paragraph
                End-if
            Else if not(SchoolDist = spaces)
                    Move "Y" to SchoolError
                    Add 1 to ThisIncidentCount
                    Add 1 to ErrorCount
            End-if.

       500-PrintErrors.
            If EmpNumError = "Y"
                Write ReportRecord from PrintEmpError
                    after advancing 1 line
            End-if
            
            If DeptError = "Y"
                Write ReportRecord from PrintDeptError
                    after advancing 1 line
            End-if
            
            If GenderError = "Y"
                Write ReportRecord from PrintGenderError 
                    after advancing 1 line
            End-if
            
            If MaritalError = "Y"
                Write ReportRecord from PrintMaritalError
                    after advancing 1 line
            End-if
            
            If PayCodeError = "Y"
                Write ReportRecord from PrintPayCodeError
                    after advancing 1 line
            End-if
            
            If HoursError = "Y"
                Write ReportRecord from PrintHoursError
                    after advancing 1 line
            End-if
            
            If HoursSignError = "Y"
                Write ReportRecord from PrintHoursSignError
                    after advancing 1 line
            End-if
            
            If ExcessiveHoursError = "Y"
                Write ReportRecord from PrintExcessiveHrs
                    after advancing 1 line
            End-if
            
            If PayError = "Y"
                Write ReportRecord from PrintPayError
                    after advancing 1 line
            End-if
            
            If PaySignError = "Y"
                Write ReportRecord from PrintPaySignError
                    after advancing 1 line
            End-if
            
            If DateNumError = "Y"
                Write ReportRecord from PrintDateNumError
                    after advancing 1 line
            End-if
            
            If DateValidError = "Y"
                Write ReportRecord from PrintDateValError
                    after advancing 1 line
            End-if
            
            If FutureDateError = "Y"
                Write ReportRecord from PrintFutureError
                    after advancing 1 line
            End-if
            
            If AgeError = "Y"
                Write ReportRecord from PrintAgeError
                    after advancing 1 line
            End-if
            
            If SchoolError = "Y"
                Write ReportRecord from PrintSchoolError
                    after advancing 1 line
            End-if.
            
       600-MoveRecords.
            Move DeptNum to DeptNumStr
            Move DeptName to DeptNameStr
            Move EmpNum to EmpNumStr
            Move LastName to LastNameStr
            Move FirstName to FirstNameStr
            Move Gender to GenderStr
            Move Street to StreetStr
            Move CityState to CityStateStr
            Move JobTitle to JobTitleStr
            Move DOBYr to DOBYrStr
            Move DOBMo to DOBMoStr
            Move DOBDay to DOBDayStr
            Move HireYr to HireYrStr
            Move HireMo to HireMoStr
            Move HireDay to HireDayStr
            Move MaritalStat to MaritalStatStr
            Move NumDep to NumDepStr
            Move SchoolDist to SchoolDistStr
            Move Medical to MedicalStr
            Move Dental to DentalStr
            Move Vision to VisionStr
            Move 401k to 401kStr
            Move PayCode to PayCodeStr
            Move Pay to PayStr
            Move Hours to HoursStr
            Move Commission to CommissionStr
            Move Sales to SalesStr.
            
       700-ResetValues.
                Move 0 to ThisIncidentCount
                Move "N" to EmpNumError DeptError GenderError
                MaritalError PayCodeError HoursError HoursSignError
                ExcessiveHoursError PayError PaySignError
                DateNumError DateValidError FutureDateError AgeError
                SchoolError.
      
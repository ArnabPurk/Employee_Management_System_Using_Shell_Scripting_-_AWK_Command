#line 4-12 is the banner section the banner is displayed on each page of the project
#we have used a package  sysvbanner to make our project name as banner
#we have built an automation code if the package is not installed then the package is auto installed when anyone runs the program
ban="EMPLOYEE MANAGEMENT"
if [ ! -n "$(dpkg -l | grep sysvbanner | awk -F ' ' '{print $2}')" ]
then
    sudo apt install sysvbanner
fi
banner $ban
if [ ! -f mydb ]; then
    touch mydb
fi
#here comes the login function which matches the id and password and  if the given input id and password matches the hardcoded
#password then the user will enter the main section of our management program
Login() {
    echo -e "\n\n\t1. Login"
    echo -e "\t2. Exit"
    echo -e "\tEnter choice: \c"
    read a
    case $a in
    1)
        clear
        banner $ban
        echo -e "\tUsername: \c"
        read user
        echo -e "\tPassword: \c"
        read -s pass
        if ((user == "group18" && pass == "1234")); then
            clear
            banner $ban
            Indroduction
        else
            clear
            banner $ban
            echo "Username or Password is not correct , please try again..."
            Login
        fi
        ;;
    2)
        clear
        exit
        ;;
    *)
        clear
        banner $ban
        Login
        ;;
    esac
}
#after successful login and user will be directed into the control pannel or management pannel section
#then these following functionalities will be provided in the display
Indroduction() {
    echo -e "\t1. Display Employee Information"
    echo -e "\t2. Add New Employee"
    echo -e "\t3. Modify Employee Information"
    echo -e "\t4. Delete Employee Information"
    echo -e "\t5. Exit"
    echo -e "\tChoice: \c"
    read ch
    case $ch in
    1)
        clear
        banner $ban
        Show
        ;;
    2)
        clear
        banner $ban
        Insertion
        ;;
    3)
        clear
        banner $ban
        Modification
        ;;
    4)
        clear
        banner $ban
        Deletion
        ;;
    5)
        clear
        exit
        ;;

    *)
        clear
        banner $ban
        Indroduction
        ;;
    esac

}
#Insertion function will be invoked when the user want to insert an employees data 
Insertion() {
    printf "Please fill the following form: "
    printf "\nEmployee ID : "
    read eid
    printf "First Name : "
    read fname
    printf "Last Name : "
    read lname
    printf "Address : "
    read addr
    printf "Date Of Birth : "
    read dob
    printf "Sex : "
    read sex
    printf "Department : "
    read dept
    printf "Salary : "
    read sal
    printf "Designation : "
    read des
    printf "Joining Date : "
    read jdate
    data=$(echo -n -e "$eid\t$fname\t$lname\t$addr\t$dob\t$sex\t$dept\t$sal\t$des\t$jdate\n") #joing all the input values together as a string separated by tabs(spaces) and storing them in data variable
    echo $data >>mydb  #write data variable into the databse mydb
    printf "\nRecord successfully added."
    printf "\nEnter any key to go back..."
    read a
    clear
    banner $ban
    Indroduction
}
#header function is for displaying the details of employees in an tab spaced tabular format
header() {
    printf "\n-------------\t----------\t---------\t-------\t-------------\t---\t----------\t------\t-----------\t------------\n"
    printf "Emp_ID\tFirst_Name\tLast_Name\tAddress\tDate_Of_Birth\tSex\tDepartment\tSalary\tDesignation\tJoining_Date\n"
    printf "\n-------------\t----------\t---------\t-------\t-------------\t---\t----------\t------\t-----------\t------------\n"
}
#Show function mainly implements various queries by which employees can be searched or sorted
#to understand this function one must know basic awk commands
Show() {
    echo -e "\t1. Display details of all employees"
    echo -e "\t2. Display details of employees of a particular department"
    echo -e "\t3. Display details of employees whose salary is between A & B"
    echo -e "\t4. Display details of all male employees"
    echo -e "\t5. Display details of all female employees"
    echo -e "\t6. Display details of all employees of a particular designation"
    echo -e "\t7. Display maximum salary offered to an employee with corresponding details"
    echo -e "\t8. Sort employee details in increasing order of salary"
    echo -e "\t9. Search employee by name"
    echo -e "\t10. Back"
    echo -e "\tChoice: \c"
    read ch
    case $ch in
    1)
        clear
        banner $ban
        acheki=$(wc mydb | awk -F ' ' '{print $1;}') #here first apply wc command to count the lines words and bytes in the mydb databse and then from the returned result set which is separated by space extract the 1st column using print $1 and store it in acheki variable
        (
            gacheki=$(wc mydb | awk -F ' ' '{print $1;}') #same explanation given on line 151
            if (($gacheki != 0)); then
                header
            fi
            awk '{print;}' mydb  #print the mydb files all data
        ) | column -t #this column -t helps to format the data in a tabular format so that the data in each column begins with the headers starting margin
        if (($acheki == 0)); then   #if linecount is 0 then there are no records
            printf "\n\n\n\t\t\t\tNO RECORDS FOUND!\n\n\n"
        fi
        printf "\nEnter any key to go back..."
        read a
        clear
        banner $ban
        Show
        ;;
    2)
        clear
        banner $ban
        printf "Enter Department : "
        read des
        khojo=$(awk -v ds=$des '{if($7==ds)print;}' mydb | wc | awk -F ' ' '{print $1}') #here we have declared an variable ds using -v and store the matches rows which match the department field from mydb and from returned resultset we have applided wordcount to see resltset is empty or not by using print $1 which means the lines in resultset
        (
            cnt=$(awk -v ds=$des '{if($7==ds)print;}' mydb | wc | awk -F ' ' '{print $1}') #same as line 173
            if (($cnt != 0)); then
                header
            fi
            awk -v ds=$des '{if($7==ds)print;}' mydb #here we have declared an variable ds using -v and store the rows which match the department field from mydb and print the reslult in the display
        ) | column -t #this column -t helps to format the data in a tabular format so that the data in each column begins with the headers starting margin
        if (($khojo == 0)); then
            printf "\n\n\n\t\t\t\tNO RECORDS FOUND!\n\n\n"
        fi
        printf "\nEnter any key to go back..."
        read a
        clear
        banner $ban
        Show
        ;;
    3)
        clear
        banner $ban
        printf "Start Salary : "
        read st
        printf "End Salary: "
        read end
        khoj=$(awk -v min=$st -v max=$end '{if($8>=min && $8<=max) print;}' mydb | wc | awk -F ' ' '{print $1}') #here we have declared two variable min and max using -v and searched for the  rows which match the salary field which is in between the minimum and maximum range given by the user (recall if else in c or c++) and from returned resultset we have applied wordcount to see resltset is empty or not by using print $1 which means the lines in resultset
        (
            khojo=$(awk -v min=$st -v max=$end '{if($8>=min && $8<=max) print;}' mydb | wc | awk -F ' ' '{print $1}') #same as line 197
            if (($khojo != 0)); then
                header
            fi
            awk -v min=$st -v max=$end '{if($8>=min && $8<=max) print;}' mydb #here we have declared two variable min and max using -v and searched for the  rows which match the salary field which is in between the minimum and maximum range given by the user (recall if else in c or c++) and atlast print the lines from returned resultset
        ) | column -t
        if (($khoj == 0)); then
            printf "\n\n\n\t\t\t\tNO RECORDS FOUND WITH THIS SALARY RANGE!\n\n\n"
        fi
        printf "\nEnter any key to go back..."
        read a
        clear
        banner $ban
        Show
        ;;
    4)
        clear
        banner $ban
        khojo=$(awk '{if($6=="Male")print;}' mydb | wc | awk -F ' ' '{print $1}')#here firstly we searched the 6th column which indicates the gender field and the matching rows which have gender as male from mydb are retured using this awk command and from returned resultset we have applided wordcount to see resltset is empty or not by using print $1 which means the lines in resultset
        (
            cnt=$(awk '{if($6=="Male")print;}' mydb | wc | awk -F ' ' '{print $1}') #same as line 217
            if (($cnt != 0)); then
                header
            fi
            awk '{if($6=="Male")print;}' mydb #here firstly we searched the 6th column which indicates the gender field and the matching rows which have gender as male from mydb are retured using this awk command and print the relevant details 
        ) | column -t
        if (($khojo == 0)); then
            printf "\n\n\n\t\t\t\tNO RECORDS FOUND!\n\n\n"
        fi
        printf "\nEnter any key to go back..."
        read a
        clear
        banner $ban
        Show
        ;;
    5)
        clear
        banner $ban
        khojo=$(awk '{if($6=="Female")print;}' mydb | wc | awk -F ' ' '{print $1}') #here firstly we searched the 6th column which indicates the gender field and the matching rows which have gender as female from mydb are retured using this awk command and from returned resultset we have applided wordcount to see resltset is empty or not by using print $1 which means the lines in resultset
        (
            cnt=$(awk '{if($6=="Female")print;}' mydb | wc | awk -F ' ' '{print $1}') #same as 237
            if (($cnt != 0)); then
                header
            fi
            awk '{if($6=="Female")print;}' mydb #here firstly we searched the 6th column which indicates the gender field and the matching rows which have gender as female from mydb are retured using this awk command and print the relevant details
        ) | column -t
        if (($khojo == 0)); then
            printf "\n\n\n\t\t\t\tNO RECORDS FOUND!\n\n\n"
        fi
        printf "\nEnter any key to go back..."
        read a
        clear
        banner $ban
        Show
        ;;
    6)
        clear
        banner $ban
        printf "Enter Designition : "
        read des
        khojo=$(awk -v ds=$des '{if($9==ds)print;}' mydb | wc | awk -F ' ' '{print $1}') #here we have declared an variable ds using -v and store the  rows which match the designition field from mydb and from returned resultset we have applied wordcount to see resltset is empty or not by using print $1 which means the lines in resultset
        (
            cnt=$(awk -v ds=$des '{if($9==ds)print;}' mydb | wc | awk -F ' ' '{print $1}') #same as line 259
            if (($cnt != 0)); then
                header
            fi
            awk -v ds=$des '{if($9==ds)print;}' mydb #here we have declared an variable ds using -v and store the rows which match the designtion field from mydb and print the reslult in the display
        ) | column -t
        if (($khojo == 0)); then
            printf "\n\n\n\t\t\t\tNO RECORDS FOUND!\n\n\n"
        fi
        printf "\nEnter any key to go back..."
        read a
        clear
        banner $ban
        Show
        ;;
    7)
        clear
        banner $ban
        acheki=$(wc mydb | awk -F ' ' '{print $1;}') #see if any reocrds exits in mydb or not
        (
            gacheki=$(wc mydb | awk -F ' ' '{print $1;}') #see if any reocrds exits in mydb or not
            if (($gacheki != 0)); then
                header
            fi
            max=$(sort -n -rk 8 mydb | head -1 | awk '{print $8}')  #sort the records to display according to the salary in decreasing order and then gain the max salary
            awk -v koto=$max '{if($8==koto) print;}' mydb  #search the employees who  have max salary(8th column is for salary)
        ) | column -t
        if (($acheki == 0)); then
            printf "\n\n\n\t\t\t\tNO RECORDS FOUND!\n\n\n"
        fi
        printf "\nEnter any key to go back..."
        read a
        clear
        banner $ban
        Show
        ;;
    8)
        clear
        banner $ban
        acheki=$(wc mydb | awk -F ' ' '{print $1;}')  #see if any reocrds exits in mydb or not
        (
            gacheki=$(wc mydb | awk -F ' ' '{print $1;}') #see if any reocrds exits in mydb or not
            if (($gacheki != 0)); then
                header
            fi
            sort -n -k 8 mydb  #sort according to salary (8 is indicating 8th column which is the salary field)
        ) | column -t
        if (($acheki == 0)); then
            printf "\n\n\n\t\t\t\tNO RECORDS FOUND!\n\n\n"
        fi
        printf "\nEnter any key to go back..."
        read a
        clear
        banner $ban
        Show
        ;;
    9)
        clear
        banner $ban
        printf "Enter First Name : "
        read fname
        printf "Enter Last Name : "
        read lname

        khojo=$(awk -v fn=$fname -v ln=$lname '{if($2==fn && $3==ln)print;}' mydb | wc | awk -F ' ' '{print $1}')  #if the firstname and lastname matches the 2nd and 3rd column of a record then the record is returned and then wordcount is applied to know the lines of reuturned resultset.
        (
            cnt=$(awk -v fn=$fname -v ln=$lname '{if($2==fn && $3==ln)print;}' mydb | wc | awk -F ' ' '{print $1}') #same as line 325
            if (($cnt != 0)); then
                header
            fi
            awk -v fn=$fname -v ln=$lname '{if($2==fn && $3==ln)print;}' mydb #if the firstname and lastname matches the 2nd and 3rd column of a record then the record is returned and print the returned records.
        ) | column -t
        if (($khojo == 0)); then
            printf "\n\n\n\t\t\t\tNO RECORDS FOUND!\n\n\n"
        fi
        printf "\nEnter any key to go back..."
        read a
        clear
        banner $ban
        Show
        ;;
    10)
        clear
        banner $ban
        Indroduction
        ;;
    *)
        clear
        banner $ban
        Show
        ;;
    esac
}
#Modification function is invoked when any employees details is to be modified
Modification() {
    clear
    banner $ban
    printf "Enter Emp_ID of the employee whose record has to be modified : "
    read mod
    khojo=$(awk -v md=$mod '{if($1==md)print;}' mydb | wc | awk -F ' ' '{print $1}') #search the employee by id and see that employee of this id exists or not
    if (($khojo == 0)); then
        printf "\n\n\n\t\t\t\tNO RECORDS FOUND TO MODIFY!\n\n\n"
    else    
        printf "\nOld details : \n"   #if the employee is found then print the old details of employee and select the column number which we want to change or modify
        (
            printf "\n-------------\t----------\t---------\t-------\t-------------\t---\t----------\t------\t-----------\t------------\n"
            printf "1\t2\t3\t4\t5\t6\t7\t8\t9\t10\n"
            printf "Emp_ID\tFirst_Name\tLast_Name\tAddress\tDate_Of_Birth\tSex\tDepartment\tSalary\tDesignation\tJoining_Date\n"
            printf "\n-------------\t----------\t---------\t-------\t-------------\t---\t----------\t------\t-----------\t------------\n"
            awk -v md=$mod '{if($1==md)print;}' mydb  #print the old records 
        ) | column -t
        printf "\nWhich field do you want to modify? Enter the field number: "
        read field
        printf "\nEnter new detail : "
        read nw
        awk -v f=$field -v m=$mod -v dibo=$nw '{if($1==m) $f=dibo;print;}' mydb >tmp && mv tmp mydb  #here we take three variables called f,m and dibo which represents field no(column number) and the  the employee id to modify and the new value to replace the old value respectively. Then after finding the desired employee we set the new value to the relevent field that user wants to modify and set the new database records as tmp and then move tmp to mydb.
        printf "\nRecord successfully modified."
        printf "\nUpdated details : \n"

        (
            header
            awk -v md=$mod '{if($1==md)print;}' mydb #print new modified values
        ) | column -t
    fi
    printf "\nEnter any key to go back..."
    read a
    clear
    banner $ban
    Indroduction
}
#Deletion function is used to delete the employees details by employee id
Deletion() {
    printf "\nEnter Emp_ID which you want to delete: "
    read emp
    khojo=$(awk -v em=$emp '{if($1==em)print;}' mydb) #search the employee user wnats to delete
    sed -i "/$khojo/d" mydb  #delete that corresponding row of that employee using sed command(which finds the khojo variable which is combined record of the employee user wants to delete) from mydb.
    printf "\nRecord deleted successfully."
    printf "\nEnter any key to go back..."
    read a
    clear
    banner $ban
    Indroduction
}
Login

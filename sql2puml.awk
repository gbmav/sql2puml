# =========================================================================
#
# sql2puml - SQL DDL to markdown converter
#
# Invocation/Execution:
#   awk -f sql2puml.awk inputfile > outputfile
#
# Supports
#   Markdown format
#   PlantUML format
#   mermaid format
#   dot format
# =========================================================================
# Globals
output_format="plantuml"
running=0

# =========================================================================
function check_arguments() {

    if (ARGC==1) {
        print_usage()
        return
    }


    for (i=1; i<= ARGC; i++) {
        if (ARGV[i] == "omd") output_format="markdown"
        if (ARGV[i] == "opl") output_format="plantuml"
        if (ARGV[i] == "ome") output_format="mermaid"
        if (ARGV[i] == "help" ) print_help()
        if (ARGV[i] == "version" ) print_version()

    }
    running=1
}

function print_usage() {
        print("Usage: sql2puml [help] [version] [omd | opl | ome ] inputsqlfile")
        exit
}

function print_version() {
    print("sql2puml Version: 0.1")
    exit
}

function print_help() {
    print("sql2puml Help")
    print("options:")
    print(" version")
    print(" help")
    print("")
    print("Examples")
    print("awk -f ddl2md -opl dump.dql")
    exit
}
function uml_start()
{
    plantuml_start()

}

function plantuml_start()
{
    print "@startuml"
    print "left to right direction"
    print "skinparam roundcorner 5"
    print "skinparam linetype ortho"
    print"skinparam shadowing false"
    print "skinparam handwritten false"
    print "skinparam class {"
    print " BackgroundColor white"
    print " ArrowColor #2688d4"
    print " BorderColor #2688d4"
    print "}"
    print"!define primary_key(x) <b><color:#b8861b><&key></color> x</b>"
    print "!define foreign_key(x) <color:#aaaaaa><&key></color> x"
    print "!define column(x) <color:#efefef><&media-record></color> x"
    print "!define table(x) entity x << (T, white) >>"

    running=1
}

function uml_end()
{
    plantuml_end()

}

function plantuml_end()
{
        print "@enduml"

}
function erase_braces(mystr)
{
    #sub("\(","",mystr)
    split(mystr,arr,"\(")
    return arr[1]
}

function uml_table(line)
# DDL to plantuml
# CREATE TABLE portfolio_details(ID INT, portfolioID INT, currencyID INT, quantity FLOAT);#table( user )
# CREATE TABLE table10_pk_and_fk (id INT PRIMARY KEY, firstname VARCHAR(100), lastname VARCHAR(100) , town_id INT, FOREIGN KEY (town_id) REFERENCES table11(id));
#table( user ) {
#  primary_key( id ): UUID
#  column( isActive ): BOOLEAN
#  foreign_key( cityId ): INTEGER <<FK>>
#}
#
{
    tablerelationships=""

    sub("CREATE TABLE","",line)
    # extract name of table and handle if there is no space between table_name and braces (
    split(line,arr,"\(")
    tablename =arr[1]
    printf("table(%s) { \n",tablename )

    # columns
    braceposition = match(line,"\(")
    revisedlength = length(line)-braceposition
    params = substr(line,braceposition,revisedlength)
    sub("\(","",params)
    sub("\)","",params)
    numparams = split(params,param,",")
    for (i=1;i<= numparams;i++) {
        # printf("%s \n",param[i])
        split(param[i], fields," ")
        cname = fields[1]
        ctype = fields[2]
        key = fields[3]

        if (match(fields[3],"PRIMARY") == 1) {
           printf("primary_key ( %s ): %s\n",cname,ctype)
        }
        else if (match(fields[3],"FOREIGN") == 1) {
            printf("foreign_key ( %s ): %s\n",cname,ctype)
            split(fields[6],fkf,"(")
            foreigntablename = fkf[1]
            foreigntablecolumn = fkf[2]
            tablerelationships=tablerelationships uml_table_relationship(tablename,foreigntablename)
        }
        else
        {
            if (cname == "FOREIGN" && ctype =="KEY")
            {
                #print("possible FOREIGN")
                #print("key",key)
                #printf("foreign_key ( %s ): %s\n",cname,ctype)
                split(fields[5],fkf,"(")
                foreigntablename = fkf[1]
                foreigntablecolumn = fkf[2]
                #print("f5 ",fields[5])
                #print("foreigntablename",foreigntablename)
                #print("foreigntablecolumn",foreigntablecolumn)
                tablerelationships=tablerelationships uml_table_relationship(tablename,foreigntablename)

            }
            else
                printf("column ( %s ): %s\n",cname,ctype)
        }
    }
    printf("}\n")
    printf("%s\n",tablerelationships)
}

function uml_table_relationship(t1,t2) {
    mystr = sprintf("%s }|--|| %s",t1,t2)
    #print("my str = ",mystr)
    return mystr
}


# =========================================================================

function uml_parse_sql_line(line)
{
    #print("uml_parse_sql_line",line)
        if (match(line,"CREATE TABLE") > 0) {
            uml_table(line)
        }
}
# =========================================================================
function uml_parse_line(line)
{
    if (length(line) < 2) {
            return
    }

    if (match(line,";")>0) {
        sql_line = sql_line line
        uml_parse_sql_line(sql_line)
        sql_line=""
    }
    else {
        sql_line = sql_line line
    }
}

# =========================================================================

BEGIN {
    check_arguments()
    uml_start()
    }

uml_parse_line($0)

END {    uml_end() }

# =========================================================================

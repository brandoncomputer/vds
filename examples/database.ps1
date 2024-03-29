    $MyForm = dialog create "My Form" 0 0 326 333
    $DataGridView1 = dialog add $MyForm DataGridView 9 22 360 150  
        $TextBox1 = dialog add $MyForm TextBox 189 28 100 20 "" 
        $TextBox2 = dialog add $MyForm TextBox 189 136 100 20 "" 
        $Button1 = dialog add $MyForm Button 214 28 75 23 "Add"  
        $Button2 = dialog add $MyForm Button 254 115 75 23 "Search"
        $SearchBox = dialog add $MyForm TextBox 254 28 75 23
		
		info "$(chr 34)Dbq=$(curdir)\vds.accdb$(chr 34)"

$dbq = ('Dbq='+($(curdir))+'\vds.accdb')

Add-OdbcDsn -Name "VDS" -DriverName "Microsoft Access Driver (*.mdb, *.accdb)" -DsnType "User" -Platform "64-bit" -SetPropertyValue "$dbq"

database open vds

function updatetable {
$q = $(database execute "select * from TestStruct where name like '%'")
$DataGridView1.ColumnCount = 2
$DataGridView1.Columns[0].Name = "Name"
$DataGridView1.Columns[1].Name = "Phone"
    for ($i=0; $i -lt $q.name.count; $i++) {
        if ($q.name.count -gt 1) {
            $DataGridView1.Rows.Add($q.name[$i],$q.phone[$i]) | Out-Null #Because $q is an array!
        }
        else {
            $DataGridView1.Rows.Add($q.name,$q.phone) | Out-Null #Because $q is a single item! $q.name[$i] would produce the first letter of the name
        }
    }
$DataGridView1.ReadOnly = $true
}

$Button1.add_Click({
    database execute ("insert into TestStruct values ("+$(chr 39)+$TextBox1.text+$(chr 39)+","+$(chr 39)+$TextBox2.text+$(chr 39)+")")
    console ("insert into TestStruct values ("+$(chr 39)+$TextBox1.text+$(chr 39)+","+$(chr 39)+$TextBox2.text+$(chr 39)+")")
    $DataGridView1.Rows.Clear()
    updatetable
})

updatetable

$Button2.add_Click({
$DataGridView1.Rows.Clear()
$q = $(database execute ("select * from TestStruct where name like '%"+$SearchBox.text+"%'"))
$DataGridView1.ColumnCount = 2
$DataGridView1.Columns[0].Name = "Name"
$DataGridView1.Columns[1].Name = "Phone"
    for ($i=0; $i -lt $q.name.count; $i++) {
        if ($q.name.count -gt 1) {
            $DataGridView1.Rows.Add($q.name[$i],$q.phone[$i]) | Out-Null #Because $q is an array!
        }
        else {
            $DataGridView1.Rows.Add($q.name,$q.phone) | Out-Null #Because $q is a single item! $q.name[$i] would produce the first letter of the name
        }
    }
$DataGridView1.ReadOnly = $true
})
    
    dialog show $MyForm
    
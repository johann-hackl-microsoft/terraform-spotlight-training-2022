
# replace all "#TF_VAR_...#" with its value in all *.tf files
# e.g. during deployment process, when downloading the files temporarily on a build agent
Write-Output ("START: {0}..." -f $PSCommandPath)

$varList = Get-ChildItem -Path env:\ | Where-Object {$_.Name -like 'TF_VAR_*'}
$tfList = Get-ChildItem -Filter "*.tf" -Recurse 

foreach ($tf in $tfList) {
    Write-Output ("- Processing {0}..." -f $tf.FullName)

    $tfContent = Get-Content -Path $tf.FullName

    foreach ($var in $varList) {
        Write-Output ("  - {0}" -f $var.Name)
        $tfContent = $tfContent -replace ("#{0}#" -f $var.Name), $var.Value
    }

    $tfContent | Set-Content -Path $tf.FullName -Force
}

Write-Output ("DONE: {0}" -f $PSCommandPath)

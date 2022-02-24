$varList = Get-ChildItem -Path env:\ | Where-Object {$_.Name -like 'TF_VAR_*'}
$tfList = Get-ChildItem -Filter "*.tf" -Recurse -Path ("{0}\.." -f $PSScriptRoot)

foreach ($tf in $tfList) {
    $tfContent = Get-Content -Path $tf.FullName -Raw

    $tfContent | Set-Content -Path $tf.FullName -Force
}
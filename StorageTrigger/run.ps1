using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
#$name = $Request.Query.Name
#if (-not $name) {
#    $name = $Request.Body.Name
#}

#$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

#if ($name) {
#    $body = "Hello, $name. This HTTP triggered function executed successfully."
#}
# Initialize these variables with your values.
$rgName = "<resource_group>";
$accountName = "<account_name";
$srcContainerName = "<source_container>";
$destContainerName = "<destination_container>";
$srcBlobName = "<name>.<extension>";
$destBlobName = "<name>.<extension>.hot"; #Overwrite issue
$blob_state = "Hot";

# Get the storage account context
$ctx = (Get-AzStorageAccount -ResourceGroupName $rgName -Name $accountName).Context

# Copy the source blob to a new destination blob in Hot tier with Standard priority.
$result = Start-AzStorageBlobCopy -SrcContainer $srcContainerName -SrcBlob $srcBlobName -DestContainer $destContainerName -DestBlob $destBlobName -StandardBlobTier $blob_state -RehydratePriority Standard -Context $ctx;
Write-Host $result;
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $result
})

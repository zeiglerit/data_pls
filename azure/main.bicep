param location string = resourceGroup().location

module storage './modules/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageName: 'fintechdata${uniqueString(resourceGroup().id)}'
  }
}

module eventhub './modules/eventhub.bicep' = {
  name: 'eventHubDeploy'
  params: {
    location: location
    namespaceName: 'fintech-events'
  }
}

module ml './modules/mlworkspace.bicep' = {
  name: 'mlWorkspaceDeploy'
  params: {
    location: location
    workspaceName: 'fintech-ml'
  }
}

module compute './modules/compute.bicep' = {
  name: 'mlComputeDeploy'
  params: {
    location: location
    workspaceName: 'fintech-ml'
    computeName: 'cpu-cluster'
  }
}

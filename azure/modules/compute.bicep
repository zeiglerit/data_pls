param location string
param workspaceName string
param computeName string

resource cpuCompute 'Microsoft.MachineLearningServices/workspaces/computes@2023-04-01' = {
  name: computeName
  parent: resourceId('Microsoft.MachineLearningServices/workspaces', workspaceName)
  location: location
  properties: {
    computeType: 'AmlCompute'
    properties: {
      vmSize: 'STANDARD_DS3_V2'
      scaleSettings: {
        minNodeCount: 0
        maxNodeCount: 4
        nodeIdleTimeBeforeScaleDown: 'PT120S'
      }
    }
  }
}

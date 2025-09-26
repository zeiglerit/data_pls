param location string
param workspaceName string

resource mlWorkspace 'Microsoft.MachineLearningServices/workspaces@2023-04-01' = {
  name: workspaceName
  location: location
  properties: {
    friendlyName: workspaceName
    description: 'Fintech ML workspace with Jupyter and TensorFlow'
  }
}

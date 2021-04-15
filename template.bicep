
param sites_confcartapp_name string = 'conflict-cartographer-django-test-bicep'
param serverfarms_confcart_app_plan_name string = 'conflict-cartographer-app-plan'

resource serverfarms_confcart_app_plan_name_resource 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: serverfarms_confcart_app_plan_name
  location: 'North Europe'
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    maximumElasticWorkerCount: 1
    isSpot: false
    freeOfferExpirationTime: '12/3/2020 2:30:00 PM'
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource sites_confcartapp_name_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: sites_confcartapp_name
  location: 'North Europe'
  kind: 'app,linux,container'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_confcartapp_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: 'conflictcartographer.prio.org'
        sslState: 'SniEnabled'
        thumbprint: '8880D4AA8F7EC480846834F18156B51E1CFF2B89'
        hostType: 'Standard'
      }
      {
        name: '${sites_confcartapp_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_confcart_app_plan_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    siteConfig: {}
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientCertEnabled: false
    hostNamesDisabled: false
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
  }
}

resource sites_confcartapp_name_web 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${sites_confcartapp_name_resource.name}/web'
  // location: 'North Europe'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'DOCKER|prioreg.azurecr.io/conflict-cartographer-django:latest'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$confcartapp'
    azureStorageAccounts: {}
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetName: '21a5d5cd-3fd4-4f99-8c96-464c64d3f107_default'
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: true
    minTlsVersion: '1.2'
    ftpsState: 'AllAllowed'
    reservedInstanceCount: 0
  }
}

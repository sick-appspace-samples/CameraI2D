
--Start of Global Scope---------------------------------------------------------

-- IP address of the connected camera, has to match the actual camera
local CAM1_IP = '192.168.1.100'

-- Creation of configuration handle
local config = Image.Provider.RemoteCamera.I2DConfig.create()
-- Applying settings to the configuration handle
Image.Provider.RemoteCamera.I2DConfig.setShutterTime(config, 5000)
Image.Provider.RemoteCamera.I2DConfig.setAcquisitionMode(
  config,
  'FIXED_FREQUENCY'
)
Image.Provider.RemoteCamera.I2DConfig.setFrameRate(config, 5)
--Additional configurations can be set according to the API

-- Creation of remote camera handle
local cam1 = Image.Provider.RemoteCamera.create()
-- Applying settings to the remote camera handle
Image.Provider.RemoteCamera.setType(cam1, 'I2DCAM')
Image.Provider.RemoteCamera.setIPAddress(cam1, CAM1_IP)
Image.Provider.RemoteCamera.setConfig(cam1, config)

-- Creation View handle
local viewer = View.create('viewer2D1')

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

--Declaration of the 'main' function as an entry point for the event loop
--@main()
local function main()
  -- Connection to camera. When the camera can connect, starting the acquisition
  local isConnected = Image.Provider.RemoteCamera.connect(cam1)
  if isConnected then
    Image.Provider.RemoteCamera.start(cam1)
  else
    print('Conection to camera failed')
  end
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--This function is called when the 'OnNewImage' event is raised
--@handleOnNewImage(image:Image,sensordata:SensorData)
local function handleOnNewImage(image, sensordata)
  -- clear view from previously displayed pictures
  viewer:clear()
  -- push the new image to the view (NOT the same as acctually displaying it!)
  viewer:addImage(image)
  -- re-render the acctual view to present the new picture
  viewer:present()

  -- Printing the additional sensor data to the console
  print('Timestamp: ' .. SensorData.getTimestamp(sensordata))
  print('Frame number: ' .. SensorData.getFrameNumber(sensordata))
  print('Image ID: ' .. SensorData.getID(sensordata))
  print('Image origin: ' .. SensorData.getOrigin(sensordata))
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'handleOnNewImage' to the 'OnNewImage' event
Image.Provider.RemoteCamera.register(cam1, 'OnNewImage', handleOnNewImage)

--End of Function and Event Scope-----------------------------------------------

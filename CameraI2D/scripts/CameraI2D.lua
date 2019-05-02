--[[----------------------------------------------------------------------------

  Application Name: CameraI2D

  Description:
  Configuration of I2D camera and image acquisition

  This sample shows the configuration of any I2D camera (picoCam/midiCam) connected
  to a SIM4000. The configuration of the camera is made in the global scope.
  The camera is then connected and started after the 'Engine.OnStarted' event
  occurred. The images can be viewed in the 2D Viewer of the SIM or the emulator.
  Additional information is printed to the console.
  To show this sample an I2D camera has to be connected correctly to the SIM4000.
  The IP address of the camera has to match the one in this script.

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

-- IP address of the connected camera, has to match the actual camera
local CAM1_IP = '192.168.0.100'

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
local viewer = View.create()
viewer:setID('viewer2D')

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
  -- Viewing the image on built in 2D Viewer of the device/emulator
  View.view(viewer, image)
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

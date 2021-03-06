% non functional example class to be used as basis for new hardware interfacing
% class, as they alls should have similar structure and content

classdef McuSerialInterface < BaseHardwareClass

  % must be implemented by the children class
  properties (Abstract = true)
    serialPort char;
    baudRate (1,1) {mustBeNumeric};
  end

  % depended properties are calculated from other properties
  properties (Dependent = true)
    bytesAvailable(1,1) {mustBeNumeric};
    isConnected(1,1) {mustBeNumericOrLogical};
  end

  % things we don't want to accidently change but that still might be interesting
  properties (Transient = true)
    SerialPortObj; % serial port object
  end

  % things we don't want to accidently change but that still might be interesting
  properties (Constant, Abstract = true)
    DO_AUTO_CONNECT; % connect when object is initialized?
    MCU_ID; % unique ID of MCU, used to id the mcu...duh
    MCU_BOOT_TIME; % [s] approximate time it takes for MCU to boot
    SERIAL_TIMEOUT; % [s] default time out while waiting for serial data etc
  end

  properties (Constant)
    %% these commands must not be changed, as they are also used 
    % in the MCU firmware...
    DO_NOTHING = uint16(00);
    RESTART_MCU = uint16(91);
    STOP = uint16(93);
    CLOSE_CONNECTION = uint16(94);
    CHECK_ID = uint16(95);
    CHECK_CONNECTION = uint16(96);
    ERROR = uint16(97);
    READY = uint16(98);
    DONE = uint16(99);
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % constructor, desctructor, save obj
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods
    % constructor, called when class is created
    function Obj = McuSerialInterface(varargin)
    end

    %*************************************************************************%
    function delete(Obj)
      if ~isempty(Obj.SerialPortObj)
        Obj.Close();
      end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % when saved, hand over only properties stored in saveObj
    function SaveObj = saveobj(Obj)
      SaveObj = Obj; % see class def for info
    end

  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods % short methods, which are not worth putting in a file
    %*************************************************************************%
    % flush serial io (input and output) buffers
    function [] = Flush_Serial(Obj)
      tic;
      nBytes = Obj.bytesAvailable;
      if nBytes
        Obj.VPrintF_With_ID('Flushing %i serial port bytes...',nBytes);
        flush(Obj.SerialPortObj);
        Obj.Done();
      end
    end

    %*************************************************************************%
    function [] = Write_16Bit(Obj, data)
      Obj.Write_Command(data); % same as command, but lets not confuse our users...
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods % set / get methods
    %*************************************************************************%
    function [bytesAvailable] = get.bytesAvailable(Obj)
      if Obj.isConnected
        bytesAvailable = Obj.SerialPortObj.NumBytesAvailable;
      else
        bytesAvailable = [];
      end
    end

    %*************************************************************************%
    function [isConnected] = get.isConnected(Obj)
      isConnected = ~isempty(Obj.SerialPortObj);
    end

  end % <<<<<<<< END SET?GET METHODS

end % <<<<<<<< END BASE CLASS

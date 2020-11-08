% wait for specific number of bytes to be available on serial port

function [success] = Wait_For_Bytes(Obj,nBytes,timeOut)
  success = false;
  if nargin < 3
    timeOut = Obj.SERIAL_TIMEOUT; % default timeout
  end

  t1 = tic;
  % wait for ready command...
  while (Obj.bytesAvailable < nBytes)
    if toc(t1) > timeOut
      Obj.Verbose_Warn('Timeout while waiting for serial data!\n');
      return;
    end
  end
  success = true;
end

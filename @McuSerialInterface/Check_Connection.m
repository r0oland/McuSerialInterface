function [success] = Check_Connection(Obj)

  Obj.Flush_Serial(); % make sure to get rid of old bytes...

  Obj.VPrintF_With_ID('Checking connection');
  Obj.Write_Command(Obj.CHECK_CONNECTION);
  
  success = Obj.Wait_For_Bytes(2); % give MCU time to answer with 2 bytes, timeout = 1s
  if success
    Obj.VPrintF('...');
    answer = Obj.Read_Command(); % read two byte answers (uint16)
    if answer == Obj.READY
      Obj.VPrintF('we are ready to go!\n');
    else
      short_warn(' unexpected return value!');
      Obj.VPrintF_With_ID('Connection was not established correctly!\n');
    end
  else
    Obj.VPrintF_With_ID('Connection was not established correctly!\n');
    return;
  end
  
  % also make sure we are connected to the right MCU 
  % as other MCUs might use same communication protocol

  Obj.VPrintF_With_ID('Checking MCU ID...');
  Obj.Write_Command(Obj.CHECK_ID);
  
  nRequiredBytes = strlength(Obj.MCU_ID); % this is how many bytes we expect
  success = Obj.Wait_For_Bytes(nRequiredBytes); % give MCU time to answer
  if success
    answer = Obj.Read_Data(nRequiredBytes,"string");
    if strcmp(answer,Obj.MCU_ID)
      Obj.VPrintF('correct MCU!\n');
      success = true;
    else
      short_warn(' Wrong MCU connected!');
    end
  else
    Obj.VPrintF_With_ID('failed due to timeout!\n');
  end


end

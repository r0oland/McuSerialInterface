% function [] = Wait_Done(Obj)
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [success] = Wait_Done(Obj)
  Obj.Wait_For_Bytes(2);
  
  answer = Obj.Read_Data(1,'uint16');
  if answer == Obj.DONE
    success = 1;
  elseif answer == Obj.ERROR
    fprintf('\n'); % make sure warning is on new line 
    short_warn('[MCU] returned error!');
    success = -1;
  else
    success = 0;
    fprintf('\n'); % make sure warning is on new line 
    short_warn('[MCU] unexpected return value:');
  end
end

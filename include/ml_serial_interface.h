#ifndef ML_SERIAL_INTERFACE
#define ML_SERIAL_INTERFACE

#include <Arduino.h>

namespace mlSerial {

  // used to send signed integers over serial port
  union WriteBuffer {
    uint8_t bytes[8];
    int64_t val;
  };
  // used to send unsigned integers over serial port
  union UWriteBuffer {
    uint8_t bytes[8];
    uint64_t val;
  };

  class MLSerial{
  public:
    uint8_t  Serial_Read_8bit();
    uint16_t Serial_Read_16bit();
    uint32_t Serial_Read_32bit();

    // send uint data as bytes over serial port
    void Serial_Write_8bit(uint8_t writeData);
    void Serial_Write_16bit(uint16_t writeData);
    void Serial_Write_32bit(uint32_t writeData);
    
    // send int data as bytes over serial port
    void Serial_Write_8bit(int8_t writeData);
    void Serial_Write_16bit(int16_t writeData);
    void Serial_Write_32bit(int32_t writeData);

    void Wait_Next_Command();
    void Wait_Bytes(int nBytes);
    bool Wait_Bytes(const int nBytes, uint32_t waitTimeout);

    uint16_t Check_For_New_Command();
    void Send_Ready();
    void Send_ID();
    void Send_Command(const uint16_t command);

    uint16_t Read_Command();

  private:
    WriteBuffer writeBuffer_;
    UWriteBuffer uwriteBuffer_;

  }; // MLSerial - class def
} // mlSerial namespace

#endif // ML_SERIAL_INTERFACE
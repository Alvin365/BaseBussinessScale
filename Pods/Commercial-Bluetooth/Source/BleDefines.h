//
//  BleDefines.h
//
//  Created by Tony You on 10/31/11.
//  Copyright (c) 2011 Jess Tech. All rights reserved.
//
#ifndef BleDefines_h
#define BleDefines_h

// Defines for peripheral
#define TI_KEYFOB_PROXIMITY_ALERT_UUID                      0x1802
#define TI_KEYFOB_PROXIMITY_ALERT_PROPERTY_UUID             0x2a06
#define TI_KEYFOB_PROXIMITY_ALERT_ON_VAL                    0x01
#define TI_KEYFOB_PROXIMITY_ALERT_OFF_VAL                   0x00
#define TI_KEYFOB_PROXIMITY_ALERT_WRITE_LEN                 1
#define TI_KEYFOB_PROXIMITY_TX_PWR_SERVICE_UUID             0x1804
#define TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_UUID        0x2A07
#define TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_READ_LEN    1

//#define TI_KEYFOB_BATT_SERVICE_UUID                         0xFFB0
//#define TI_KEYFOB_LEVEL_SERVICE_UUID                        0xFFB1
#define TI_KEYFOB_BATT_SERVICE_UUID                         0x180F
#define TI_KEYFOB_LEVEL_SERVICE_UUID                        0x2A19
#define TI_KEYFOB_POWER_STATE_UUID                          0xFFB2
#define TI_KEYFOB_LEVEL_SERVICE_READ_LEN                    1

#define TI_KEYFOB_ACCEL_SERVICE_UUID                        0xFFA0
#define TI_KEYFOB_ACCEL_ENABLER_UUID                        0xFFA1
#define TI_KEYFOB_ACCEL_RANGE_UUID                          0xFFA2
#define TI_KEYFOB_ACCEL_READ_LEN                            1
#define TI_KEYFOB_ACCEL_X_UUID                              0xFFA3
#define TI_KEYFOB_ACCEL_Y_UUID                              0xFFA4
#define TI_KEYFOB_ACCEL_Z_UUID                              0xFFA5

#define TI_KEYFOB_KEYS_SERVICE_UUID                         0xFFE0
#define TI_KEYFOB_KEYS_NOTIFICATION_UUID                    0xFFE1
#define TI_KEYFOB_KEYS_NOTIFICATION_READ_LEN                1

//ISSC
#define ISSC_SERVICE_UUID                                   @"FFF0"
#define ISSC_CHAR_RX_UUID                                   @"FFF1"
#define ISSC_CHAR_TX_UUID                                   @"FFF2"

//JD UUDI
#define JD_SERVICE_UUID                                     @"D618D000-6000-1000-8000-000000000000"
#define JD_CHAR_RX_UUID                                     @"D618D002-6000-1000-8000-000000000000"
#define JD_CHAR_TX_UUID                                     @"D618D001-6000-1000-8000-000000000000"

//HR
#define HR_SERVICE_UUID                                     0x180D
#define HR_HEART_RATE_MEASUREMENT                           0x2A37  //notify
#define HR_BODY_SENSOR_LOCATION                             0x2A38  //read
#define HR_HEARE_RATE_CONTROL_POINT                         0x2A39  //write


#endif













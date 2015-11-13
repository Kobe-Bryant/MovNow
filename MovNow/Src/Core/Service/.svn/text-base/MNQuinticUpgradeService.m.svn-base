//
//  MNQuinticUpgradeService.m
//  Movnow
//
//  Created by baoyx on 15/5/7.
//  Copyright (c) 2015年 HelloWorld. All rights reserved.
//

#import "MNQuinticUpgradeService.h"
#import "MNBleBaseService.h"
#import "MNDeviceBindingService.h"
#import "QBleClient.h"
#import <CoreBluetooth/CoreBluetooth.h>
// 加密函数
typedef void (^UpgradeProgress)(int progress);   //升级进度
static unsigned short ccitt_table[256] = {
    0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50A5, 0x60C6, 0x70E7, 0x8108, 0x9129, 0xA14A, 0xB16B, 0xC18C, 0xD1AD, 0xE1CE, 0xF1EF, 0x1231, 0x0210, 0x3273, 0x2252, 0x52B5, 0x4294, 0x72F7, 0x62D6, 0x9339, 0x8318, 0xB37B, 0xA35A, 0xD3BD, 0xC39C, 0xF3FF, 0xE3DE, 0x2462, 0x3443, 0x0420, 0x1401, 0x64E6, 0x74C7, 0x44A4, 0x5485, 0xA56A, 0xB54B, 0x8528, 0x9509, 0xE5EE, 0xF5CF, 0xC5AC, 0xD58D, 0x3653, 0x2672, 0x1611, 0x0630, 0x76D7, 0x66F6, 0x5695, 0x46B4, 0xB75B, 0xA77A, 0x9719, 0x8738, 0xF7DF, 0xE7FE, 0xD79D, 0xC7BC, 0x48C4, 0x58E5, 0x6886, 0x78A7, 0x0840, 0x1861, 0x2802, 0x3823, 0xC9CC, 0xD9ED, 0xE98E, 0xF9AF, 0x8948, 0x9969, 0xA90A, 0xB92B, 0x5AF5, 0x4AD4, 0x7AB7, 0x6A96, 0x1A71, 0x0A50, 0x3A33, 0x2A12,0xDBFD, 0xCBDC, 0xFBBF, 0xEB9E, 0x9B79, 0x8B58, 0xBB3B, 0xAB1A, 0x6CA6, 0x7C87, 0x4CE4, 0x5CC5, 0x2C22, 0x3C03, 0x0C60, 0x1C41, 0xEDAE, 0xFD8F, 0xCDEC, 0xDDCD, 0xAD2A, 0xBD0B, 0x8D68, 0x9D49, 0x7E97, 0x6EB6, 0x5ED5, 0x4EF4, 0x3E13, 0x2E32, 0x1E51, 0x0E70, 0xFF9F, 0xEFBE, 0xDFDD, 0xCFFC, 0xBF1B, 0xAF3A, 0x9F59, 0x8F78, 0x9188, 0x81A9, 0xB1CA, 0xA1EB, 0xD10C, 0xC12D, 0xF14E, 0xE16F, 0x1080, 0x00A1, 0x30C2, 0x20E3, 0x5004, 0x4025, 0x7046, 0x6067, 0x83B9, 0x9398, 0xA3FB, 0xB3DA, 0xC33D, 0xD31C, 0xE37F, 0xF35E, 0x02B1, 0x1290, 0x22F3, 0x32D2, 0x4235, 0x5214, 0x6277, 0x7256, 0xB5EA, 0xA5CB, 0x95A8, 0x8589, 0xF56E, 0xE54F, 0xD52C, 0xC50D, 0x34E2, 0x24C3, 0x14A0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405, 0xA7DB, 0xB7FA, 0x8799, 0x97B8, 0xE75F, 0xF77E, 0xC71D, 0xD73C, 0x26D3, 0x36F2, 0x0691, 0x16B0, 0x6657, 0x7676, 0x4615, 0x5634, 0xD94C, 0xC96D, 0xF90E, 0xE92F, 0x99C8, 0x89E9, 0xB98A, 0xA9AB, 0x5844, 0x4865, 0x7806, 0x6827, 0x18C0, 0x08E1, 0x3882, 0x28A3, 0xCB7D, 0xDB5C, 0xEB3F, 0xFB1E, 0x8BF9, 0x9BD8, 0xABBB, 0xBB9A, 0x4A75, 0x5A54, 0x6A37, 0x7A16, 0x0AF1, 0x1AD0, 0x2AB3, 0x3A92, 0xFD2E, 0xED0F, 0xDD6C, 0xCD4D, 0xBDAA, 0xAD8B, 0x9DE8, 0x8DC9, 0x7C26, 0x6C07, 0x5C64, 0x4C45, 0x3CA2, 0x2C83, 0x1CE0, 0x0CC1, 0xEF1F, 0xFF3E, 0xCF5D, 0xDF7C, 0xAF9B, 0xBFBA, 0x8FD9, 0x9FF8, 0x6E17, 0x7E36, 0x4E55, 0x5E74, 0x2E93, 0x3EB2, 0x0ED1, 0x1EF0
};

unsigned short crc_ccitt(unsigned char *q, int len) {
    unsigned short crc = 0;
    while (len-- > 0) {
        crc = ccitt_table[(crc >> 8 ^ *q++) & 0xff] ^ (crc << 8); }
    return ~crc;
}
@interface MNQuinticUpgradeService ()<MNBleBaseServiceQuinticUpgradeDelegate>

@end
@implementation MNQuinticUpgradeService
{
    CoreSuccess upgradeSucBlock_;
    CoreFailure upgradeFailureBlock_;
    UpgradeProgress upgradeProgressBlock_;
    
    // ble version 固件升级缓冲区
    int versionLength;                  //固件大小
    Byte versionData[60000];            //保存固件数据
    NSInteger versionSendPacketNum;           //长包序号
    NSMutableArray *versionSendDataArr;  //保存一个长包的数据，每发送一个短包就增加一个obj
    NSInteger packetNumTotal;           //长包个数
    Byte transferStateTable[15];        //一个长包的位域表
    
    // 重发控制
    int resendTimes_;
    NSTimer *resendTimer_;
    
    BOOL isDropBag;     //是否掉包
    BOOL isSendFF;                  //判断固件升级完成， 是否发送完最后一个包
    qBleClient *bleClient;
}

+(MNQuinticUpgradeService *)shareInstance
{
    static MNQuinticUpgradeService *simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simple = [[MNQuinticUpgradeService alloc] init];
    });
    return simple;
}

-(instancetype)init
{
    if (self == [super init]) {
        bleClient = [qBleClient sharedInstance];
    }
    return self;
}

-(void)startQuinticUpgradeProgress:(void (^)(int progress))progress withSuccess:(CoreFailure)success withFailure:(CoreFailure)failure
{
    upgradeSucBlock_ = [success copy];
    upgradeFailureBlock_ = [failure copy];
    upgradeProgressBlock_ = [progress copy];
    versionSendDataArr=[NSMutableArray array];
    versionSendPacketNum=1;
    versionLength = [MNDeviceBindingService readLocalBLEVersionData:versionData];
    packetNumTotal=(versionLength%BLE_VERSION_DATA_PACKET_LENGTH)?(versionLength/BLE_VERSION_DATA_PACKET_LENGTH)+1:(versionLength/BLE_VERSION_DATA_PACKET_LENGTH);
    DLog(@"本地固件文件长度：%ld", (long)versionLength);
    DLog(@"本地固件文件一共长包数：%ld", (long)packetNumTotal);
    int chk =crc_ccitt(versionData, versionLength);
    Byte temp[20]={0};
    temp[0]=0x5A;
    temp[0] = 0x5A;
    temp[1] = 0x11;
    temp[2] = 0x00;
    temp[3] = versionLength/(256*256*256);
    temp[4] = versionLength%(256*256*256)/(256*256);
    temp[5] = versionLength%(256*256)/256;
    temp[6] = versionLength%256;
    temp[7] = chk/256;
    temp[8] = chk%256;
    temp[9] = BLE_VERSION_DATA_PACKET_LENGTH/256;
    temp[10] = BLE_VERSION_DATA_PACKET_LENGTH%256;
    temp[11] = BLE_VERSION_TIME_OUT;
    temp[12] = BLE_VERSION_RESEND_TIMES;
    NSData *data = [NSData dataWithBytes:temp length:20];
    [bleClient sendData:data withFailure:^(id reason) {
        upgradeFailureBlock_(@"");
    }];
}


#pragma mark 接受位域表

-(void)receiveDomainTableWithbyte:(Byte *)data withlength:(int)len
{
    for (int i=0; i<15; i++) {
        int temp=data[5+i];
        for (int j=0; j<8; j++) {
            if(((temp>>j)&1)!=0)
            {
                [bleClient sendData:versionSendDataArr[i*8+j] withFailure:^(id reason) {
                    DLog(@"reason=%@",reason);
                }];
                isDropBag=YES;
            }
        }
    }
    if(isDropBag)
    {
        return;
    }
    
    Byte temp[5]={0};
    temp[0]=0x5A;
    temp[1]=0x05;
    temp[3]=versionSendPacketNum/256;
    temp[4]=versionSendPacketNum%256;
    NSData *sendData = [NSData dataWithBytes:temp length:5];
    [bleClient sendData:sendData withFailure:^(id reason) {
        DLog(@"reason=%@",reason);
    }];
    
    
}

-(void)updateBLEData
{
    [versionSendDataArr removeAllObjects];
    [self cleanTransferStateTable];
    [self updateBLEVersionDataPos:(int)versionSendPacketNum];
}

-(void)updateBLEVersionDataPos:(int)packNum
{
    int len=0;
    if(packNum *BLE_VERSION_DATA_PACKET_LENGTH>versionLength)
    {
        len=versionLength%BLE_VERSION_DATA_PACKET_LENGTH;
    }else
    {
        len=BLE_VERSION_DATA_PACKET_LENGTH;
    }
    int chk=crc_ccitt(versionData+(packNum-1)*BLE_VERSION_DATA_PACKET_LENGTH, len);
    
    int shortCount= (len%17)?(len/17+2):(len/17+1);
    for(int i=0;i<shortCount;i++)
    {
        if(i ==0)
        {
            Byte temp[20] = {0};
            temp[0] = 0x5A;
            temp[1] = 0x05;
            temp[2] = i+1;
            
            //设置包长度
            temp[3]=len/256;
            temp[4]=len%256;
            temp[5]=packNum/256;
            temp[6]=packNum%256;
            temp[7]=chk/256;
            temp[8]=chk%256;
            temp[9]=0x11;
            NSData *data=[NSData dataWithBytes:temp length:20];
            [bleClient sendData:data withFailure:^(id reason) {
                DLog(@"reason=%@",reason);
            }];
            [versionSendDataArr addObject:data];
        }else
        {
            Byte temp[20] = {0};
            temp[0] = 0x5A;
            temp[1] = 0x05;
            temp[2] = i+1;
            int pLen=(i==shortCount-1)?(len%17+3):20;
            for(int j=3;j<pLen;j++)
            {
                int k=(packNum-1)*BLE_VERSION_DATA_PACKET_LENGTH+(i-1)*17+(j-3);
                DLog(@"k=%d pLen=%d,j=%d",k,pLen,j);
                temp[j]=versionData[k];
                if(k==versionLength-1)
                {
                    
                    DLog(@"-----k=%d pLen=%d,j=%d",k,pLen,j);
                    temp[2]=0xff;
                    isSendFF=YES;
                    NSData *data = [NSData dataWithBytes:temp length:pLen];
                    [bleClient sendData:data withFailure:^(id reason) {
                        DLog(@"reason=%@",reason);
                    }];
                    [versionSendDataArr addObject:data];
                    return;
                }
            }
            if(i==shortCount-1 && temp[2] !=0xff)
            {
                temp[2]=0xfe;
                NSData *data = [NSData dataWithBytes:temp length:len%17+3];
                [bleClient sendData:data withFailure:^(id reason) {
                    DLog(@"reason=%@",reason);
                }];
                [versionSendDataArr addObject:data];
                return;
            }
            NSData *data = [NSData dataWithBytes:temp length:20];
            [bleClient sendData:data withFailure:^(id reason) {
                DLog(@"reason=%@",reason);
            }];
            [versionSendDataArr addObject:data];
        }
        
    }
}

//停止重发机制
-(void)stopResendTimer
{
    if(resendTimer_)
    {
        [resendTimer_ invalidate];
        resendTimer_=nil;
    }
    resendTimes_=0;
}

//清空位域表

-(void)cleanTransferStateTable
{
    NSLog(@"清空位域表");
    for (int i = 0; i<15; i++) {
        transferStateTable[i] = 0xFF;
    }
}
#pragma mark --------------------MNBleBaseServiceQuinticUpgradeDelegate---------------------
-(void)receviceQuinticUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Rev:%@  Length:%d",characteristic.value,(int)characteristic.value.length);
    int length = (int)[characteristic.value length];
    Byte temp[length];
    [characteristic.value getBytes:temp length:length];
    
    
    switch (temp[0]) {
        case 0x5B:
        {
            [self receive5BWithLength:length data:temp];
        }
            break;
        case 0X5A:
        {
            [self receive5AWithLength:length data:temp];
        }
            
        default:
            break;
    }
}

-(void)receive5AWithLength:(int)length data:(Byte *)temp
{
    switch (temp[1]) {
        case 0x06:
        {
            [self stopResendTimer];
            // 升级进度block
            DLog(@"versionSendPacketNum:%ld",(long)versionSendPacketNum);
            DLog(@"packetNumTotal:%ld",(long)packetNumTotal);
            DLog(@"升级进度:%d",(int)((versionSendPacketNum/(float)packetNumTotal)*100));
            upgradeProgressBlock_((int)((versionSendPacketNum/(float)packetNumTotal)*100));
            versionSendPacketNum++;
            //发送下一个长包
            
            if(isSendFF && temp[3] == 0xff && temp[4] == 0xff)
            {
                upgradeSucBlock_(@"");
                return;
            }
            [self updateBLEData];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)receive5BWithLength:(int)length data:(Byte *)temp
{
    
    switch (temp[1]) {
        case 0x11:
        {
            [self stopResendTimer];
            if(temp[3]==0)
            {
                upgradeFailureBlock_(@"设备不支持固件升级");
            }else
            {
                //发送升级包
                upgradeProgressBlock_(0);
                [self updateBLEData];
                
            }
        }
            break;
        case 0x05:
        {
            // 接收位域表
            NSLog(@"//接收到，位域表");
            [self receiveDomainTableWithbyte:temp withlength:length];
            
        }
            break;
            
        default:
            break;
    }
}


@end

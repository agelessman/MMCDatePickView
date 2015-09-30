//
//  MCDatePickDefine.h
//  text
//
//  Created by 马超 on 15/9/29.
//  Copyright © 2015年 马超. All rights reserved.
//

#ifndef MCDatePickDefine_h
#define MCDatePickDefine_h

#define MCWeakify(o)        __weak   typeof(self) mcwo = o;
#define MCStrongify(o)      __strong typeof(self) o = mcwo;
#define MCHexColor(color)   [UIColor mc_colorWithHex:color]
#define MC_SPLIT_WIDTH      (1/[UIScreen mainScreen].scale)



#endif /* MCDatePickDefine_h */

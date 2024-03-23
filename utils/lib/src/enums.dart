// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum USState {
  AL,
  AK,
  AZ,
  AR,
  CA,
  CO,
  CT,
  DE,
  FL,
  GA,
  HI,
  ID,
  IL,
  IN,
  IA,
  KS,
  KY,
  LA,
  ME,
  MD,
  MA,
  MI,
  MN,
  MS,
  MO,
  MT,
  NE,
  NV,
  NH,
  NJ,
  NM,
  NY,
  NC,
  ND,
  OH,
  OK,
  OR,
  PA,
  RI,
  SC,
  SD,
  TN,
  TX,
  UT,
  VT,
  VA,
  WA,
  WV,
  WI,
  WY;

  String get fullName {
    switch (this) {
      case USState.AL:
        return 'Alabama';
      case USState.AK:
        return 'Alaska';
      case USState.AZ:
        return 'Arizona';
      case USState.AR:
        return 'Arkansas';
      case USState.CA:
        return 'California';
      case USState.CO:
        return 'Colorado';
      case USState.CT:
        return 'Connecticut';
      case USState.DE:
        return 'Delaware';
      case USState.FL:
        return 'Florida';
      case USState.GA:
        return 'Georgia';
      case USState.HI:
        return 'Hawaii';
      case USState.ID:
        return 'Idaho';
      case USState.IL:
        return 'Illinois';
      case USState.IN:
        return 'Indiana';
      case USState.IA:
        return 'Iowa';
      case USState.KS:
        return 'Kansas';
      case USState.KY:
        return 'Kentucky';
      case USState.LA:
        return 'Louisiana';
      case USState.ME:
        return 'Maine';
      case USState.MD:
        return 'Maryland';
      case USState.MA:
        return 'Massachusetts';
      case USState.MI:
        return 'Michigan';
      case USState.MN:
        return 'Minnesota';
      case USState.MS:
        return 'Mississippi';
      case USState.MO:
        return 'Missouri';
      case USState.MT:
        return 'Montana';
      case USState.NE:
        return 'Nebraska';
      case USState.NV:
        return 'Nevada';
      case USState.NH:
        return 'New Hampshire';
      case USState.NJ:
        return 'New Jersey';
      case USState.NM:
        return 'New Mexico';
      case USState.NY:
        return 'New York';
      case USState.NC:
        return 'North Carolina';
      case USState.ND:
        return 'North Dakota';
      case USState.OH:
        return 'Ohio';
      case USState.OK:
        return 'Oklahoma';
      case USState.OR:
        return 'Oregon';
      case USState.PA:
        return 'Pennsylvania';
      case USState.RI:
        return 'Rhode Island';
      case USState.SC:
        return 'South Carolina';
      case USState.SD:
        return 'South Dakota';
      case USState.TN:
        return 'Tennessee';
      case USState.TX:
        return 'Texas';
      case USState.UT:
        return 'Utah';
      case USState.VT:
        return 'Vermont';
      case USState.VA:
        return 'Virginia';
      case USState.WA:
        return 'Washington';
      case USState.WV:
        return 'West Virginia';
      case USState.WI:
        return 'Wisconsin';
      case USState.WY:
        return 'Wyoming';
    }
  }
}

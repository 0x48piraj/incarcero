unit UnitBandeiras;

interface

uses
  windows,
  UnitDiversos,
  UnitServerUtils;

function GetCountryCode(Abreviacao: string): integer;
function GetCountryName(Abreviacao: String = ''; Code: integer = 348): string;
function GetActiveKeyboardLanguage: string;
function GetCountryAbreviacao: string;

implementation

function GetActiveKeyboardLanguage: string;
Var
  LayoutName : Array [0..KL_NAMELENGTH] of Char;
  LangName   : Array [0..63] of Char;
  LangName2   : Array [0..63] of Char;
begin
  GetKeyboardLayoutName(@LayoutName);
  GetLocaleInfo(StrToInt('$' + LayoutName), LOCALE_SENGLANGUAGE, @LangName, 64);
  GetLocaleInfo(StrToInt('$' + LayoutName), LOCALE_SLANGUAGE, @LangName2, 64);
  Result := LangName + ' "' + LangName2 + '"';
end;

function GetCountryAbreviacao: string;
var
  IsValidCountryCode  :Boolean;
  CountryCode: Array[0..4] of Char;
begin
  result := '';
  IsValidCountryCode := (3 = GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SISO3166CTRYNAME, CountryCode, SizeOf(CountryCode)));
  if IsValidCountryCode then result := Pchar(@CountryCode[0]);
end;

function GetCountryName(Abreviacao: String = ''; Code: integer = 348): string;
begin
  Abreviacao := UpperString(Abreviacao);
  Result := 'Unknown';

  if (Abreviacao = 'AF') or (Code = 0) then Result := 'Afghanistan' else
  if (Abreviacao = 'AX') or (Code = 1) then Result := 'Aland Islands' else
  if (Abreviacao = 'AL') or (Code = 2) then Result := 'Albania' else
  if (Abreviacao = 'DZ') or (Code = 3) then Result := 'Algeria' else
  if (Abreviacao = 'AS') or (Code = 4) then Result := 'American Samoa' else
  if (Abreviacao = 'AD') or (Code = 5) then Result := 'Andorra' else
  if (Abreviacao = 'AO') or (Code = 6) then Result := 'Angola' else
  if (Abreviacao = 'AI') or (Code = 7) then Result := 'Anguilla' else
  if (Abreviacao = 'AG') or (Code = 8) then Result := 'Antigua and Barbuda' else
  if (Abreviacao = 'AR') or (Code = 9) then Result := 'Argentina' else
  if (Abreviacao = 'AM') or (Code = 10) then Result := 'Armenia' else
  if (Abreviacao = 'AW') or (Code = 11) then Result := 'Aruba' else
  if (Abreviacao = 'AU') or (Code = 12) then Result := 'Australia' else
  if (Abreviacao = 'AT') or (Code = 13) then Result := 'Austria' else
  if (Abreviacao = 'AZ') or (Code = 14) then Result := 'Azerbaijan' else
  if (Abreviacao = 'BS') or (Code = 15) then Result := 'Bahamas' else
  if (Abreviacao = 'BH') or (Code = 16) then Result := 'Bahrain' else
  if (Abreviacao = 'BD') or (Code = 17) then Result := 'Bangladesh' else
  if (Abreviacao = 'BB') or (Code = 18) then Result := 'Barbados' else
  if (Abreviacao = 'BY') or (Code = 19) then Result := 'Belarus' else
  if (Abreviacao = 'BE') or (Code = 20) then Result := 'Belgium' else
  if (Abreviacao = 'BZ') or (Code = 21) then Result := 'Belize' else
  if (Abreviacao = 'BJ') or (Code = 22) then Result := 'Benin' else
  if (Abreviacao = 'BM') or (Code = 23) then Result := 'Bermuda' else
  if (Abreviacao = 'BT') or (Code = 24) then Result := 'Bhutan' else
  if (Abreviacao = 'BO') or (Code = 25) then Result := 'Bolivia, Plurinational State of' else
  if (Abreviacao = 'BA') or (Code = 26) then Result := 'Bosnia and Herzegovina' else
  if (Abreviacao = 'BW') or (Code = 27) then Result := 'Botswana' else
  if (Abreviacao = 'BV') or (Code = 28) then Result := 'Bouvet Island' else
  if (Abreviacao = 'BR') or (Code = 29) then Result := 'Brazil' else
  if (Abreviacao = 'IO') or (Code = 30) then Result := 'British Indian Ocean Territory' else
  if (Abreviacao = 'BN') or (Code = 31) then Result := 'Brunei Darussalam' else
  if (Abreviacao = 'BG') or (Code = 32) then Result := 'Bulgaria' else
  if (Abreviacao = 'BF') or (Code = 33) then Result := 'Burkina Faso' else
  if (Abreviacao = 'BI') or (Code = 34) then Result := 'Burundi' else
  if (Abreviacao = 'KH') or (Code = 35) then Result := 'Cambodia' else
  if (Abreviacao = 'CM') or (Code = 36) then Result := 'Cameroon' else
  if (Abreviacao = 'CA') or (Code = 37) then Result := 'Canada' else
  if (Abreviacao = 'CV') or (Code = 38) then Result := 'Cape Verde' else
  if (Abreviacao = 'KY') or (Code = 39) then Result := 'Cayman Islands' else
  if (Abreviacao = 'CF') or (Code = 40) then Result := 'Central African Republic' else
  if (Abreviacao = 'TD') or (Code = 41) then Result := 'Chad' else
  if (Abreviacao = 'CL') or (Code = 42) then Result := 'Chile' else
  if (Abreviacao = 'CN') or (Code = 43) then Result := 'China' else
  if (Abreviacao = 'CX') or (Code = 44) then Result := 'Christmas Island' else
  if (Abreviacao = 'CC') or (Code = 45) then Result := 'Cocos (Keeling) Islands' else
  if (Abreviacao = 'CO') or (Code = 46) then Result := 'Colombia' else
  if (Abreviacao = 'KM') or (Code = 47) then Result := 'Comoros' else
  if (Abreviacao = 'CG') or (Code = 48) then Result := 'Congo' else
  if (Abreviacao = 'CD') or (Code = 49) then Result := 'Congo, Democratic Republic of the' else
  if (Abreviacao = 'CK') or (Code = 50) then Result := 'Cook Islands' else
  if (Abreviacao = 'CR') or (Code = 51) then Result := 'Costa Rica' else
  if (Abreviacao = 'CI') or (Code = 52) then Result := 'Cote d''Ivoire' else
  if (Abreviacao = 'HR') or (Code = 53) then Result := 'Croatia' else
  if (Abreviacao = 'CU') or (Code = 54) then Result := 'Cuba' else
  if (Abreviacao = 'CY') or (Code = 55) then Result := 'Cyprus' else
  if (Abreviacao = 'CZ') or (Code = 56) then Result := 'Czech Republic' else
  if (Abreviacao = 'DK') or (Code = 57) then Result := 'Denmark' else
  if (Abreviacao = 'DJ') or (Code = 58) then Result := 'Djibouti' else
  if (Abreviacao = 'DM') or (Code = 59) then Result := 'Dominica' else
  if (Abreviacao = 'DO') or (Code = 60) then Result := 'Dominican Republic' else
  if (Abreviacao = 'EC') or (Code = 61) then Result := 'Ecuador' else
  if (Abreviacao = 'EG') or (Code = 62) then Result := 'Egypt' else
  if (Abreviacao = 'SV') or (Code = 63) then Result := 'El Salvador' else
  if (Abreviacao = 'GQ') or (Code = 64) then Result := 'Equatorial Guinea' else
  if (Abreviacao = 'ER') or (Code = 65) then Result := 'Eritrea' else
  if (Abreviacao = 'EE') or (Code = 66) then Result := 'Estonia' else
  if (Abreviacao = 'ET') or (Code = 67) then Result := 'Ethiopia' else
  if (Abreviacao = 'FK') or (Code = 68) then Result := 'Falkland Islands (Malvinas)' else
  if (Abreviacao = 'FO') or (Code = 69) then Result := 'Faroe Islands' else
  if (Abreviacao = 'FJ') or (Code = 70) then Result := 'Fiji' else
  if (Abreviacao = 'FI') or (Code = 71) then Result := 'Finland' else
  if (Abreviacao = 'FR') or (Code = 72) then Result := 'France' else
  if (Abreviacao = 'GF') or (Code = 73) then Result := 'French Guiana' else
  if (Abreviacao = 'PF') or (Code = 74) then Result := 'French Polynesia' else
  if (Abreviacao = 'TF') or (Code = 75) then Result := 'French Southern Territories' else
  if (Abreviacao = 'GA') or (Code = 76) then Result := 'Gabon' else
  if (Abreviacao = 'GM') or (Code = 77) then Result := 'Gambia' else
  if (Abreviacao = 'GE') or (Code = 78) then Result := 'Georgia' else
  if (Abreviacao = 'DE') or (Code = 79) then Result := 'Germany' else
  if (Abreviacao = 'GH') or (Code = 80) then Result := 'Ghana' else
  if (Abreviacao = 'GI') or (Code = 81) then Result := 'Gibraltar' else
  if (Abreviacao = 'GR') or (Code = 82) then Result := 'Greece' else
  if (Abreviacao = 'GL') or (Code = 83) then Result := 'Greenland' else
  if (Abreviacao = 'GD') or (Code = 84) then Result := 'Grenada' else
  if (Abreviacao = 'GP') or (Code = 85) then Result := 'Guadeloupe' else
  if (Abreviacao = 'GU') or (Code = 86) then Result := 'Guam' else
  if (Abreviacao = 'GT') or (Code = 87) then Result := 'Guatemala' else
  if (Abreviacao = 'GG') or (Code = 88) then Result := 'Guernsey' else
  if (Abreviacao = 'GN') or (Code = 89) then Result := 'Guinea' else
  if (Abreviacao = 'GW') or (Code = 90) then Result := 'Guinea-Bissau' else
  if (Abreviacao = 'GY') or (Code = 91) then Result := 'Guyana' else
  if (Abreviacao = 'HT') or (Code = 92) then Result := 'Haiti' else
  if (Abreviacao = 'HM') or (Code = 93) then Result := 'Heard Island and McDonald Islands' else
  if (Abreviacao = 'VA') or (Code = 94) then Result := 'Holy See (Vatican City State)' else
  if (Abreviacao = 'HN') or (Code = 95) then Result := 'Honduras' else
  if (Abreviacao = 'HK') or (Code = 96) then Result := 'Hong Kong' else
  if (Abreviacao = 'HU') or (Code = 97) then Result := 'Hungary' else
  if (Abreviacao = 'IS') or (Code = 98) then Result := 'Iceland' else
  if (Abreviacao = 'IN') or (Code = 99) then Result := 'India' else
  if (Abreviacao = 'ID') or (Code = 100) then Result := 'Indonesia' else
  if (Abreviacao = 'IR') or (Code = 101) then Result := 'Iran, Islamic Republic of' else
  if (Abreviacao = 'IQ') or (Code = 102) then Result := 'Iraq' else
  if (Abreviacao = 'IE') or (Code = 103) then Result := 'Ireland' else
  if (Abreviacao = 'IM') or (Code = 104) then Result := 'Isle of Man' else
  if (Abreviacao = 'IL') or (Code = 105) then Result := 'Israel' else
  if (Abreviacao = 'IT') or (Code = 106) then Result := 'Italy' else
  if (Abreviacao = 'JM') or (Code = 107) then Result := 'Jamaica' else
  if (Abreviacao = 'JP') or (Code = 108) then Result := 'Japan' else
  if (Abreviacao = 'JE') or (Code = 109) then Result := 'Jersey' else
  if (Abreviacao = 'JO') or (Code = 110) then Result := 'Jordan' else
  if (Abreviacao = 'KZ') or (Code = 111) then Result := 'Kazakhstan' else
  if (Abreviacao = 'KE') or (Code = 112) then Result := 'Kenya' else
  if (Abreviacao = 'KI') or (Code = 113) then Result := 'Kiribati' else
  if (Abreviacao = 'KP') or (Code = 114) then Result := 'Korea, Democratic People''s Republic of' else
  if (Abreviacao = 'KR') or (Code = 115) then Result := 'Korea, Republic of' else
  if (Abreviacao = 'KW') or (Code = 116) then Result := 'Kuwait' else
  if (Abreviacao = 'KG') or (Code = 117) then Result := 'Kyrgyzstan' else
  if (Abreviacao = 'LA') or (Code = 118) then Result := 'Lao People''s Democratic Republic' else
  if (Abreviacao = 'LV') or (Code = 119) then Result := 'Latvia' else
  if (Abreviacao = 'LB') or (Code = 120) then Result := 'Lebanon' else
  if (Abreviacao = 'LS') or (Code = 121) then Result := 'Lesotho' else
  if (Abreviacao = 'LR') or (Code = 122) then Result := 'Liberia' else
  if (Abreviacao = 'LY') or (Code = 123) then Result := 'Libyan Arab Jamahiriya' else
  if (Abreviacao = 'LI') or (Code = 124) then Result := 'Liechtenstein' else
  if (Abreviacao = 'LT') or (Code = 125) then Result := 'Lithuania' else
  if (Abreviacao = 'LU') or (Code = 126) then Result := 'Luxembourg' else
  if (Abreviacao = 'MO') or (Code = 127) then Result := 'Macao' else
  if (Abreviacao = 'MK') or (Code = 128) then Result := 'Macedonia, the former Yugoslav Republic of' else
  if (Abreviacao = 'MG') or (Code = 129) then Result := 'Madagascar' else
  if (Abreviacao = 'MW') or (Code = 130) then Result := 'Malawi' else
  if (Abreviacao = 'MY') or (Code = 131) then Result := 'Malaysia' else
  if (Abreviacao = 'MV') or (Code = 132) then Result := 'Maldives' else
  if (Abreviacao = 'ML') or (Code = 133) then Result := 'Mali' else
  if (Abreviacao = 'MT') or (Code = 134) then Result := 'Malta' else
  if (Abreviacao = 'MH') or (Code = 135) then Result := 'Marshall Islands' else
  if (Abreviacao = 'MQ') or (Code = 136) then Result := 'Martinique' else
  if (Abreviacao = 'MR') or (Code = 137) then Result := 'Mauritania' else
  if (Abreviacao = 'MU') or (Code = 138) then Result := 'Mauritius' else
  if (Abreviacao = 'YT') or (Code = 139) then Result := 'Mayotte' else
  if (Abreviacao = 'MX') or (Code = 140) then Result := 'Mexico' else
  if (Abreviacao = 'FM') or (Code = 141) then Result := 'Micronesia, Federated States of' else
  if (Abreviacao = 'MD') or (Code = 142) then Result := 'Moldova, Republic of' else
  if (Abreviacao = 'MC') or (Code = 143) then Result := 'Monaco' else
  if (Abreviacao = 'MN') or (Code = 144) then Result := 'Mongolia' else
  if (Abreviacao = 'ME') or (Code = 145) then Result := 'Montenegro' else
  if (Abreviacao = 'MS') or (Code = 146) then Result := 'Montserrat' else
  if (Abreviacao = 'MA') or (Code = 147) then Result := 'Morocco' else
  if (Abreviacao = 'MZ') or (Code = 148) then Result := 'Mozambique' else
  if (Abreviacao = 'MM') or (Code = 149) then Result := 'Myanmar' else
  if (Abreviacao = 'NA') or (Code = 150) then Result := 'Namibia' else
  if (Abreviacao = 'NR') or (Code = 151) then Result := 'Nauru' else
  if (Abreviacao = 'NP') or (Code = 152) then Result := 'Nepal' else
  if (Abreviacao = 'NL') or (Code = 153) then Result := 'Netherlands' else
  if (Abreviacao = 'AN') or (Code = 154) then Result := 'Netherlands Antilles' else
  if (Abreviacao = 'NC') or (Code = 155) then Result := 'New Caledonia' else
  if (Abreviacao = 'NZ') or (Code = 156) then Result := 'New Zealand' else
  if (Abreviacao = 'NI') or (Code = 157) then Result := 'Nicaragua' else
  if (Abreviacao = 'NE') or (Code = 158) then Result := 'Niger' else
  if (Abreviacao = 'NG') or (Code = 159) then Result := 'Nigeria' else
  if (Abreviacao = 'NU') or (Code = 160) then Result := 'Niue' else
  if (Abreviacao = 'NF') or (Code = 161) then Result := 'Norfolk Island' else
  if (Abreviacao = 'MP') or (Code = 162) then Result := 'Northern Mariana Islands' else
  if (Abreviacao = 'NO') or (Code = 163) then Result := 'Norway' else
  if (Abreviacao = 'OM') or (Code = 164) then Result := 'Oman' else
  if (Abreviacao = 'PK') or (Code = 165) then Result := 'Pakistan' else
  if (Abreviacao = 'PW') or (Code = 166) then Result := 'Palau' else
  if (Abreviacao = 'PS') or (Code = 167) then Result := 'Palestinian Territory, Occupied' else
  if (Abreviacao = 'PA') or (Code = 168) then Result := 'Panama' else
  if (Abreviacao = 'PG') or (Code = 169) then Result := 'Papua New Guinea' else
  if (Abreviacao = 'PY') or (Code = 170) then Result := 'Paraguay' else
  if (Abreviacao = 'PE') or (Code = 171) then Result := 'Peru' else
  if (Abreviacao = 'PH') or (Code = 172) then Result := 'Philippines' else
  if (Abreviacao = 'PN') or (Code = 173) then Result := 'Pitcairn' else
  if (Abreviacao = 'PL') or (Code = 174) then Result := 'Poland' else
  if (Abreviacao = 'PT') or (Code = 175) then Result := 'Portugal' else
  if (Abreviacao = 'PR') or (Code = 176) then Result := 'Puerto Rico' else
  if (Abreviacao = 'QA') or (Code = 177) then Result := 'Qatar' else
  if (Abreviacao = 'RE') or (Code = 178) then Result := 'Reunion ? Réunion' else
  if (Abreviacao = 'RO') or (Code = 179) then Result := 'Romania' else
  if (Abreviacao = 'RU') or (Code = 180) then Result := 'Russian Federation' else
  if (Abreviacao = 'RW') or (Code = 181) then Result := 'Rwanda' else
  if (Abreviacao = 'BL') or (Code = 182) then Result := 'Saint Barthélemy' else
  if (Abreviacao = 'SH') or (Code = 183) then Result := 'Saint Helena' else
  if (Abreviacao = 'KN') or (Code = 184) then Result := 'Saint Kitts and Nevis' else
  if (Abreviacao = 'LC') or (Code = 185) then Result := 'Saint Lucia' else
  if (Abreviacao = 'MF') or (Code = 186) then Result := 'Saint Martin (French part)' else
  if (Abreviacao = 'PM') or (Code = 187) then Result := 'Saint Pierre and Miquelon' else
  if (Abreviacao = 'VC') or (Code = 188) then Result := 'Saint Vincent and the Grenadines' else
  if (Abreviacao = 'WS') or (Code = 189) then Result := 'Samoa' else
  if (Abreviacao = 'SM') or (Code = 190) then Result := 'San Marino' else
  if (Abreviacao = 'ST') or (Code = 191) then Result := 'Sao Tome and Principe' else
  if (Abreviacao = 'SA') or (Code = 192) then Result := 'Saudi Arabia' else
  if (Abreviacao = 'SN') or (Code = 193) then Result := 'Senegal' else
  if (Abreviacao = 'RS') or (Code = 194) then Result := 'Serbia' else
  if (Abreviacao = 'SC') or (Code = 195) then Result := 'Seychelles' else
  if (Abreviacao = 'SL') or (Code = 196) then Result := 'Sierra Leone' else
  if (Abreviacao = 'SG') or (Code = 197) then Result := 'Singapore' else
  if (Abreviacao = 'SK') or (Code = 198) then Result := 'Slovakia' else
  if (Abreviacao = 'SI') or (Code = 199) then Result := 'Slovenia' else
  if (Abreviacao = 'SB') or (Code = 200) then Result := 'Solomon Islands' else
  if (Abreviacao = 'SO') or (Code = 201) then Result := 'Somalia' else
  if (Abreviacao = 'ZA') or (Code = 202) then Result := 'South Africa' else
  if (Abreviacao = 'GS') or (Code = 203) then Result := 'South Georgia and the South Sandwich Islands' else
  if (Abreviacao = 'ES') or (Code = 204) then Result := 'Spain' else
  if (Abreviacao = 'LK') or (Code = 205) then Result := 'Sri Lanka' else
  if (Abreviacao = 'SD') or (Code = 206) then Result := 'Sudan' else
  if (Abreviacao = 'SR') or (Code = 207) then Result := 'Suriname' else
  if (Abreviacao = 'SJ') or (Code = 208) then Result := 'Svalbard and Jan Mayen' else
  if (Abreviacao = 'SZ') or (Code = 209) then Result := 'Swaziland' else
  if (Abreviacao = 'SE') or (Code = 210) then Result := 'Sweden' else
  if (Abreviacao = 'CH') or (Code = 211) then Result := 'Switzerland' else
  if (Abreviacao = 'SY') or (Code = 212) then Result := 'Syrian Arab Republic' else
  if (Abreviacao = 'TJ') or (Code = 213) then Result := 'Tajikistan' else
  if (Abreviacao = 'TZ') or (Code = 214) then Result := 'Tanzania, United Republic of' else
  if (Abreviacao = 'TH') or (Code = 215) then Result := 'Thailand' else
  if (Abreviacao = 'TL') or (Code = 216) then Result := 'Timor-Leste' else
  if (Abreviacao = 'TG') or (Code = 217) then Result := 'Togo' else
  if (Abreviacao = 'TK') or (Code = 218) then Result := 'Tokelau' else
  if (Abreviacao = 'TO') or (Code = 219) then Result := 'Tonga' else
  if (Abreviacao = 'TT') or (Code = 220) then Result := 'Trinidad and Tobago' else
  if (Abreviacao = 'TN') or (Code = 221) then Result := 'Tunisia' else
  if (Abreviacao = 'TR') or (Code = 222) then Result := 'Turkey' else
  if (Abreviacao = 'TM') or (Code = 223) then Result := 'Turkmenistan' else
  if (Abreviacao = 'TC') or (Code = 224) then Result := 'Turks and Caicos Islands' else
  if (Abreviacao = 'TV') or (Code = 225) then Result := 'Tuvalu' else
  if (Abreviacao = 'UG') or (Code = 226) then Result := 'Uganda' else
  if (Abreviacao = 'UA') or (Code = 227) then Result := 'Ukraine' else
  if (Abreviacao = 'AE') or (Code = 228) then Result := 'United Arab Emirates' else
  if (Abreviacao = 'GB') or (Code = 229) then Result := 'United Kingdom' else
  if (Abreviacao = 'US') or (Code = 230) then Result := 'United States' else
  if (Abreviacao = 'UM') or (Code = 231) then Result := 'United States Minor Outlying Islands' else
  if (Abreviacao = 'UY') or (Code = 232) then Result := 'Uruguay' else
  if (Abreviacao = 'UZ') or (Code = 233) then Result := 'Uzbekistan' else
  if (Abreviacao = 'VU') or (Code = 234) then Result := 'Vanuatu' else
  if (Abreviacao = 'VE') or (Code = 235) then Result := 'Venezuela, Bolivarian Republic of' else
  if (Abreviacao = 'VN') or (Code = 236) then Result := 'Viet Nam' else
  if (Abreviacao = 'VG') or (Code = 237) then Result := 'Virgin Islands, British' else
  if (Abreviacao = 'VI') or (Code = 238) then Result := 'Virgin Islands, U.S.' else
  if (Abreviacao = 'WF') or (Code = 239) then Result := 'Wallis and Futuna' else
  if (Abreviacao = 'YE') or (Code = 240) then Result := 'Yemen' else
  if (Abreviacao = 'ZM') or (Code = 241) then Result := 'Zambia' else
  if (Abreviacao = 'ZW') or (Code = 242) then Result := 'Zimbabwe';
end;

function GetCountryCode(Abreviacao: string): integer;
begin
  if Abreviacao = 'AF' then Result := 0 else
  if Abreviacao = 'AX' then Result := 1 else
  if Abreviacao = 'AL' then Result := 2 else
  if Abreviacao = 'DZ' then Result := 3 else
  if Abreviacao = 'AS' then Result := 4 else
  if Abreviacao = 'AD' then Result := 5 else
  if Abreviacao = 'AO' then Result := 6 else
  if Abreviacao = 'AI' then Result := 7 else
  if Abreviacao = 'AG' then Result := 8 else
  if Abreviacao = 'AR' then Result := 9 else
  if Abreviacao = 'AM' then Result := 10 else
  if Abreviacao = 'AW' then Result := 11 else
  if Abreviacao = 'AU' then Result := 12 else
  if Abreviacao = 'AT' then Result := 13 else
  if Abreviacao = 'AZ' then Result := 14 else
  if Abreviacao = 'BS' then Result := 15 else
  if Abreviacao = 'BH' then Result := 16 else
  if Abreviacao = 'BD' then Result := 17 else
  if Abreviacao = 'BB' then Result := 18 else
  if Abreviacao = 'BY' then Result := 19 else
  if Abreviacao = 'BE' then Result := 20 else
  if Abreviacao = 'BZ' then Result := 21 else
  if Abreviacao = 'BJ' then Result := 22 else
  if Abreviacao = 'BM' then Result := 23 else
  if Abreviacao = 'BT' then Result := 24 else
  if Abreviacao = 'BO' then Result := 25 else
  if Abreviacao = 'BA' then Result := 26 else
  if Abreviacao = 'BW' then Result := 27 else
  if Abreviacao = 'BV' then Result := 28 else
  if Abreviacao = 'BR' then Result := 29 else
  if Abreviacao = 'IO' then Result := 30 else
  if Abreviacao = 'BN' then Result := 31 else
  if Abreviacao = 'BG' then Result := 32 else
  if Abreviacao = 'BF' then Result := 33 else
  if Abreviacao = 'BI' then Result := 34 else
  if Abreviacao = 'KH' then Result := 35 else
  if Abreviacao = 'CM' then Result := 36 else
  if Abreviacao = 'CA' then Result := 37 else
  if Abreviacao = 'CV' then Result := 38 else
  if Abreviacao = 'KY' then Result := 39 else
  if Abreviacao = 'CF' then Result := 40 else
  if Abreviacao = 'TD' then Result := 41 else
  if Abreviacao = 'CL' then Result := 42 else
  if Abreviacao = 'CN' then Result := 43 else
  if Abreviacao = 'CX' then Result := 44 else
  if Abreviacao = 'CC' then Result := 45 else
  if Abreviacao = 'CO' then Result := 46 else
  if Abreviacao = 'KM' then Result := 47 else
  if Abreviacao = 'CG' then Result := 48 else
  if Abreviacao = 'CD' then Result := 49 else
  if Abreviacao = 'CK' then Result := 50 else
  if Abreviacao = 'CR' then Result := 51 else
  if Abreviacao = 'CI' then Result := 52 else
  if Abreviacao = 'HR' then Result := 53 else
  if Abreviacao = 'CU' then Result := 54 else
  if Abreviacao = 'CY' then Result := 55 else
  if Abreviacao = 'CZ' then Result := 56 else
  if Abreviacao = 'DK' then Result := 57 else
  if Abreviacao = 'DJ' then Result := 58 else
  if Abreviacao = 'DM' then Result := 59 else
  if Abreviacao = 'DO' then Result := 60 else
  if Abreviacao = 'EC' then Result := 61 else
  if Abreviacao = 'EG' then Result := 62 else
  if Abreviacao = 'SV' then Result := 63 else
  if Abreviacao = 'GQ' then Result := 64 else
  if Abreviacao = 'ER' then Result := 65 else
  if Abreviacao = 'EE' then Result := 66 else
  if Abreviacao = 'ET' then Result := 67 else
  if Abreviacao = 'FK' then Result := 68 else
  if Abreviacao = 'FO' then Result := 69 else
  if Abreviacao = 'FJ' then Result := 70 else
  if Abreviacao = 'FI' then Result := 71 else
  if Abreviacao = 'FR' then Result := 72 else
  if Abreviacao = 'GF' then Result := 73 else
  if Abreviacao = 'PF' then Result := 74 else
  if Abreviacao = 'TF' then Result := 75 else
  if Abreviacao = 'GA' then Result := 76 else
  if Abreviacao = 'GM' then Result := 77 else
  if Abreviacao = 'GE' then Result := 78 else
  if Abreviacao = 'DE' then Result := 79 else
  if Abreviacao = 'GH' then Result := 80 else
  if Abreviacao = 'GI' then Result := 81 else
  if Abreviacao = 'GR' then Result := 82 else
  if Abreviacao = 'GL' then Result := 83 else
  if Abreviacao = 'GD' then Result := 84 else
  if Abreviacao = 'GP' then Result := 85 else
  if Abreviacao = 'GU' then Result := 86 else
  if Abreviacao = 'GT' then Result := 87 else
  if Abreviacao = 'GG' then Result := 88 else
  if Abreviacao = 'GN' then Result := 89 else
  if Abreviacao = 'GW' then Result := 90 else
  if Abreviacao = 'GY' then Result := 91 else
  if Abreviacao = 'HT' then Result := 92 else
  if Abreviacao = 'HM' then Result := 93 else
  if Abreviacao = 'VA' then Result := 94 else
  if Abreviacao = 'HN' then Result := 95 else
  if Abreviacao = 'HK' then Result := 96 else
  if Abreviacao = 'HU' then Result := 97 else
  if Abreviacao = 'IS' then Result := 98 else
  if Abreviacao = 'IN' then Result := 99 else
  if Abreviacao = 'ID' then Result := 100 else
  if Abreviacao = 'IR' then Result := 101 else
  if Abreviacao = 'IQ' then Result := 102 else
  if Abreviacao = 'IE' then Result := 103 else
  if Abreviacao = 'IM' then Result := 104 else
  if Abreviacao = 'IL' then Result := 105 else
  if Abreviacao = 'IT' then Result := 106 else
  if Abreviacao = 'JM' then Result := 107 else
  if Abreviacao = 'JP' then Result := 108 else
  if Abreviacao = 'JE' then Result := 109 else
  if Abreviacao = 'JO' then Result := 110 else
  if Abreviacao = 'KZ' then Result := 111 else
  if Abreviacao = 'KE' then Result := 112 else
  if Abreviacao = 'KI' then Result := 113 else
  if Abreviacao = 'KP' then Result := 114 else
  if Abreviacao = 'KR' then Result := 115 else
  if Abreviacao = 'KW' then Result := 116 else
  if Abreviacao = 'KG' then Result := 117 else
  if Abreviacao = 'LA' then Result := 118 else
  if Abreviacao = 'LV' then Result := 119 else
  if Abreviacao = 'LB' then Result := 120 else
  if Abreviacao = 'LS' then Result := 121 else
  if Abreviacao = 'LR' then Result := 122 else
  if Abreviacao = 'LY' then Result := 123 else
  if Abreviacao = 'LI' then Result := 124 else
  if Abreviacao = 'LT' then Result := 125 else
  if Abreviacao = 'LU' then Result := 126 else
  if Abreviacao = 'MO' then Result := 127 else
  if Abreviacao = 'MK' then Result := 128 else
  if Abreviacao = 'MG' then Result := 129 else
  if Abreviacao = 'MW' then Result := 130 else
  if Abreviacao = 'MY' then Result := 131 else
  if Abreviacao = 'MV' then Result := 132 else
  if Abreviacao = 'ML' then Result := 133 else
  if Abreviacao = 'MT' then Result := 134 else
  if Abreviacao = 'MH' then Result := 135 else
  if Abreviacao = 'MQ' then Result := 136 else
  if Abreviacao = 'MR' then Result := 137 else
  if Abreviacao = 'MU' then Result := 138 else
  if Abreviacao = 'YT' then Result := 139 else
  if Abreviacao = 'MX' then Result := 140 else
  if Abreviacao = 'FM' then Result := 141 else
  if Abreviacao = 'MD' then Result := 142 else
  if Abreviacao = 'MC' then Result := 143 else
  if Abreviacao = 'MN' then Result := 144 else
  if Abreviacao = 'ME' then Result := 145 else
  if Abreviacao = 'MS' then Result := 146 else
  if Abreviacao = 'MA' then Result := 147 else
  if Abreviacao = 'MZ' then Result := 148 else
  if Abreviacao = 'MM' then Result := 149 else
  if Abreviacao = 'NA' then Result := 150 else
  if Abreviacao = 'NR' then Result := 151 else
  if Abreviacao = 'NP' then Result := 152 else
  if Abreviacao = 'NL' then Result := 153 else
  if Abreviacao = 'AN' then Result := 154 else
  if Abreviacao = 'NC' then Result := 155 else
  if Abreviacao = 'NZ' then Result := 156 else
  if Abreviacao = 'NI' then Result := 157 else
  if Abreviacao = 'NE' then Result := 158 else
  if Abreviacao = 'NG' then Result := 159 else
  if Abreviacao = 'NU' then Result := 160 else
  if Abreviacao = 'NF' then Result := 161 else
  if Abreviacao = 'MP' then Result := 162 else
  if Abreviacao = 'NO' then Result := 163 else
  if Abreviacao = 'OM' then Result := 164 else
  if Abreviacao = 'PK' then Result := 165 else
  if Abreviacao = 'PW' then Result := 166 else
  if Abreviacao = 'PS' then Result := 167 else
  if Abreviacao = 'PA' then Result := 168 else
  if Abreviacao = 'PG' then Result := 169 else
  if Abreviacao = 'PY' then Result := 170 else
  if Abreviacao = 'PE' then Result := 171 else
  if Abreviacao = 'PH' then Result := 172 else
  if Abreviacao = 'PN' then Result := 173 else
  if Abreviacao = 'PL' then Result := 174 else
  if Abreviacao = 'PT' then Result := 175 else
  if Abreviacao = 'PR' then Result := 176 else
  if Abreviacao = 'QA' then Result := 177 else
  if Abreviacao = 'RE' then Result := 178 else
  if Abreviacao = 'RO' then Result := 179 else
  if Abreviacao = 'RU' then Result := 180 else
  if Abreviacao = 'RW' then Result := 181 else
  if Abreviacao = 'BL' then Result := 182 else
  if Abreviacao = 'SH' then Result := 183 else
  if Abreviacao = 'KN' then Result := 184 else
  if Abreviacao = 'LC' then Result := 185 else
  if Abreviacao = 'MF' then Result := 186 else
  if Abreviacao = 'PM' then Result := 187 else
  if Abreviacao = 'VC' then Result := 188 else
  if Abreviacao = 'WS' then Result := 189 else
  if Abreviacao = 'SM' then Result := 190 else
  if Abreviacao = 'ST' then Result := 191 else
  if Abreviacao = 'SA' then Result := 192 else
  if Abreviacao = 'SN' then Result := 193 else
  if Abreviacao = 'RS' then Result := 194 else
  if Abreviacao = 'SC' then Result := 195 else
  if Abreviacao = 'SL' then Result := 196 else
  if Abreviacao = 'SG' then Result := 197 else
  if Abreviacao = 'SK' then Result := 198 else
  if Abreviacao = 'SI' then Result := 199 else
  if Abreviacao = 'SB' then Result := 200 else
  if Abreviacao = 'SO' then Result := 201 else
  if Abreviacao = 'ZA' then Result := 202 else
  if Abreviacao = 'GS' then Result := 203 else
  if Abreviacao = 'ES' then Result := 204 else
  if Abreviacao = 'LK' then Result := 205 else
  if Abreviacao = 'SD' then Result := 206 else
  if Abreviacao = 'SR' then Result := 207 else
  if Abreviacao = 'SJ' then Result := 208 else
  if Abreviacao = 'SZ' then Result := 209 else
  if Abreviacao = 'SE' then Result := 210 else
  if Abreviacao = 'CH' then Result := 211 else
  if Abreviacao = 'SY' then Result := 212 else
  if Abreviacao = 'TJ' then Result := 213 else
  if Abreviacao = 'TZ' then Result := 214 else
  if Abreviacao = 'TH' then Result := 215 else
  if Abreviacao = 'TL' then Result := 216 else
  if Abreviacao = 'TG' then Result := 217 else
  if Abreviacao = 'TK' then Result := 218 else
  if Abreviacao = 'TO' then Result := 219 else
  if Abreviacao = 'TT' then Result := 220 else
  if Abreviacao = 'TN' then Result := 221 else
  if Abreviacao = 'TR' then Result := 222 else
  if Abreviacao = 'TM' then Result := 223 else
  if Abreviacao = 'TC' then Result := 224 else
  if Abreviacao = 'TV' then Result := 225 else
  if Abreviacao = 'UG' then Result := 226 else
  if Abreviacao = 'UA' then Result := 227 else
  if Abreviacao = 'AE' then Result := 228 else
  if Abreviacao = 'GB' then Result := 229 else
  if Abreviacao = 'US' then Result := 230 else
  if Abreviacao = 'UM' then Result := 231 else
  if Abreviacao = 'UY' then Result := 232 else
  if Abreviacao = 'UZ' then Result := 233 else
  if Abreviacao = 'VU' then Result := 234 else
  if Abreviacao = 'VE' then Result := 235 else
  if Abreviacao = 'VN' then Result := 236 else
  if Abreviacao = 'VG' then Result := 237 else
  if Abreviacao = 'VI' then Result := 238 else
  if Abreviacao = 'WF' then Result := 239 else
  if Abreviacao = 'YE' then Result := 240 else
  if Abreviacao = 'ZM' then Result := 241 else
  if Abreviacao = 'ZW' then Result := 242 else Result := 348;
end;

end.

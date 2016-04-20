{ *********************************************************************** }
{                                                                         }
{ Windows Cryptography Unit                                               }
{                                                                         }
{ Copyright (c) 2011-2016 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit Winapi.WinCrypt;

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

interface

uses
  Winapi.Windows;

{$HPPEMIT '#include <WinCrypt.h>'}

type
  ALG_ID     = UINT;
  {$EXTERNALSYM ALG_ID}
  HCRYPTPROV = ULONG_PTR;
  {$EXTERNALSYM HCRYPTPROV}
  TCryptProv = HCRYPTPROV;

  HCRYPTKEY  = ULONG_PTR;
  {$EXTERNALSYM HCRYPTKEY}
  TCryptKey  = HCRYPTKEY;

  HCRYPTHASH = ULONG_PTR;
  {$EXTERNALSYM HCRYPTHASH}
  TCryptHash = HCRYPTHASH;

  _HMAC_INFO = record
    HashAlgId: ALG_ID;
    pbInnerString: PByte;
    cbInnerString: DWORD;
    pbOuterString: PByte;
    cbOuterString: DWORD;
  end;
  {$EXTERNALSYM _HMAC_INFO}
  HMAC_INFO = _HMAC_INFO;
  {$EXTERNALSYM HMAC_INFO}
  PHMAC_INFO = ^HMAC_INFO;
  {$EXTERNALSYM PHMAC_INFO}
  THMacInfo = HMAC_INFO;

const
  crypt32                = 'Crypt32.dll';

  { ProviderType }
  PROV_RSA_FULL          = 1;
  {$EXTERNALSYM PROV_RSA_FULL}
  PROV_RSA_SIG           = 2;
  {$EXTERNALSYM PROV_RSA_SIG}
  PROV_DSS               = 3;
  {$EXTERNALSYM PROV_DSS}
  PROV_FORTEZZA          = 4;
  {$EXTERNALSYM PROV_FORTEZZA}
  PROV_MS_EXCHANGE       = 5;
  {$EXTERNALSYM PROV_MS_EXCHANGE}
  PROV_SSL               = 6;
  {$EXTERNALSYM PROV_SSL}
  PROV_RSA_SCHANNEL      = 12;
  {$EXTERNALSYM PROV_RSA_SCHANNEL}
  PROV_DSS_DH            = 13;
  {$EXTERNALSYM PROV_DSS_DH}
  PROV_EC_ECDSA_SIG      = 14;
  {$EXTERNALSYM PROV_EC_ECDSA_SIG}
  PROV_EC_ECNRA_SIG      = 15;
  {$EXTERNALSYM PROV_EC_ECNRA_SIG}
  PROV_EC_ECDSA_FULL     = 16;
  {$EXTERNALSYM PROV_EC_ECDSA_FULL}
  PROV_EC_ECNRA_FULL     = 17;
  {$EXTERNALSYM PROV_EC_ECNRA_FULL}
  PROV_DH_SCHANNEL       = 18;
  {$EXTERNALSYM PROV_DH_SCHANNEL}
  PROV_SPYRUS_LYNKS      = 20;
  {$EXTERNALSYM PROV_SPYRUS_LYNKS}
  PROV_RNG               = 21;
  {$EXTERNALSYM PROV_RNG}
  PROV_INTEL_SEC         = 22;
  {$EXTERNALSYM PROV_INTEL_SEC}
  PROV_REPLACE_OWF       = 23;
  {$EXTERNALSYM PROV_REPLACE_OWF}
  PROV_RSA_AES           = 24;
  {$EXTERNALSYM PROV_RSA_AES}

  { Algorithm classes }
  ALG_CLASS_ANY          = 0;
  {$EXTERNALSYM ALG_CLASS_ANY}
  ALG_CLASS_SIGNATURE    = 1 shl 13;
  {$EXTERNALSYM ALG_CLASS_SIGNATURE}
  ALG_CLASS_MSG_ENCRYPT  = 2 shl 13;
  {$EXTERNALSYM ALG_CLASS_MSG_ENCRYPT}
  ALG_CLASS_DATA_ENCRYPT = 3 shl 13;
  {$EXTERNALSYM ALG_CLASS_DATA_ENCRYPT}
  ALG_CLASS_HASH         = 4 shl 13;
  {$EXTERNALSYM ALG_CLASS_HASH}
  ALG_CLASS_KEY_EXCHANGE = 5 shl 13;
  {$EXTERNALSYM ALG_CLASS_KEY_EXCHANGE}
  ALG_CLASS_ALL          = 7 shl 13;
  {$EXTERNALSYM ALG_CLASS_ALL}

  { Algorithm types }
  ALG_TYPE_ANY           = 0;
  {$EXTERNALSYM ALG_TYPE_ANY}
  ALG_TYPE_DSS           = 1 shl 9;
  {$EXTERNALSYM ALG_TYPE_DSS}
  ALG_TYPE_RSA           = 2 shl 9;
  {$EXTERNALSYM ALG_TYPE_RSA}
  ALG_TYPE_BLOCK         = 3 shl 9;
  {$EXTERNALSYM ALG_TYPE_BLOCK}
  ALG_TYPE_STREAM        = 4 shl 9;
  {$EXTERNALSYM ALG_TYPE_STREAM}
  ALG_TYPE_DH            = 5 shl 9;
  {$EXTERNALSYM ALG_TYPE_DH}
  ALG_TYPE_SECURECHANNEL = 6 shl 9;
  {$EXTERNALSYM ALG_TYPE_SECURECHANNEL}

  { Hash algorithm identifiers }
  ALG_SID_MD5            = 3;
  {$EXTERNALSYM ALG_SID_MD5}
  ALG_SID_SHA            = 4;
  {$EXTERNALSYM ALG_SID_SHA}
  ALG_SID_SHA1           = 4;
  {$EXTERNALSYM ALG_SID_SHA1}
  ALG_SID_MAC            = 5;
  {$EXTERNALSYM ALG_SID_MAC}
  ALG_SID_HMAC           = 9;
  {$EXTERNALSYM ALG_SID_HMAC}
  ALG_SID_SHA_256        = 12;
  {$EXTERNALSYM ALG_SID_SHA_256}
  ALG_SID_SHA_384        = 13;
  {$EXTERNALSYM ALG_SID_SHA_384}
  ALG_SID_SHA_512        = 14;
  {$EXTERNALSYM ALG_SID_SHA_512}

  { Advanced Encryption Standard (AES) algorithm identifiers }
  ALG_SID_AES            = 17;
  {$EXTERNALSYM ALG_SID_AES}
  ALG_SID_AES_128        = 14;
  {$EXTERNALSYM ALG_SID_AES_128}
  ALG_SID_AES_192        = 15;
  {$EXTERNALSYM ALG_SID_AES_192}
  ALG_SID_AES_256        = 16;
  {$EXTERNALSYM ALG_SID_AES_256}

  { Diffie-Hellman algorithm identifiers }
  ALG_SID_DH_SANDF       = 1;
  {$EXTERNALSYM ALG_SID_DH_SANDF}
  ALG_SID_DH_EPHEM       = 2;
  {$EXTERNALSYM ALG_SID_DH_EPHEM}
  ALG_SID_AGREED_KEY_ANY = 3;
  {$EXTERNALSYM ALG_SID_AGREED_KEY_ANY}
  ALG_SID_KEA            = 4;
  {$EXTERNALSYM ALG_SID_KEA}

  { Advanced Encryption Standard (AES) algorithm }
  CALG_AES               = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES);
  {$EXTERNALSYM CALG_AES}
  CALG_AES_128           = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES_128);
  {$EXTERNALSYM CALG_AES_128}
  CALG_AES_192           = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES_192);
  {$EXTERNALSYM CALG_AES_192}
  CALG_AES_256           = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES_256);
  {$EXTERNALSYM CALG_AES_256}

  { Cipher algorithm modes }
  CRYPT_MODE_CBC         = 1;    // Cipher block chaining
  {$EXTERNALSYM CRYPT_MODE_CBC}
  CRYPT_MODE_ECB         = 2;    // Electronic code book
  {$EXTERNALSYM CRYPT_MODE_ECB}
  CRYPT_MODE_OFB         = 3;    // Output feedback mode
  {$EXTERNALSYM CRYPT_MODE_OFB}
  CRYPT_MODE_CFB         = 4;    // Cipher feedback mode
  {$EXTERNALSYM CRYPT_MODE_CFB}
  CRYPT_MODE_CTS         = 5;    // Ciphertext stealing mode
  {$EXTERNALSYM CRYPT_MODE_CTS}

  { Deprecated hashing algorithms }
  CALG_MD5               = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD5);
  {$EXTERNALSYM CALG_MD5}
  CALG_SHA               = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA);
  {$EXTERNALSYM CALG_SHA}
  CALG_SHA_160           = CALG_SHA;
  {$EXTERNALSYM CALG_SHA_160}

  { Message authentication code algorithms }
  CALG_MAC               = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MAC);
  {$EXTERNALSYM CALG_MAC}
  CALG_HMAC              = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_HMAC);
  {$EXTERNALSYM CALG_HMAC}

  { SHA-2 hashing algorithm }
  CALG_SHA_256           = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA_256);
  {$EXTERNALSYM CALG_SHA_256}
  CALG_SHA_384           = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA_384);
  {$EXTERNALSYM CALG_SHA_384}
  CALG_SHA_512           = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA_512);
  {$EXTERNALSYM CALG_SHA_512}

  { Diffie-Hellman algorithm }
  CALG_DH_SF             = (ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_DH_SANDF);
  {$EXTERNALSYM CALG_DH_SF}
  CALG_DH_EPHEM          = (ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_DH_EPHEM);
  {$EXTERNALSYM CALG_DH_EPHEM}

  { Hash algorithm flags }
  HP_ALGID               = $00000001;
  {$EXTERNALSYM HP_ALGID}
  HP_HASHVAL             = $00000002;
  {$EXTERNALSYM HP_HASHVAL}
  HP_HASHSIZE            = $00000004;
  {$EXTERNALSYM HP_HASHSIZE}
  HP_HMAC_INFO           = $00000005;
  {$EXTERNALSYM HP_HMAC_INFO}
  HP_TLS1PRF_LABEL       = $00000006;
  {$EXTERNALSYM HP_TLS1PRF_LABEL}
  HP_TLS1PRF_SEED        = $00000007;
  {$EXTERNALSYM HP_TLS1PRF_SEED}

  { dwParam }
  KP_IV                  = 1;    // Initialization vector
  {$EXTERNALSYM KP_IV}
  KP_SALT                = 2;    // Salt value
  {$EXTERNALSYM KP_SALT}
  KP_PADDING             = 3;    // Padding values
  {$EXTERNALSYM KP_PADDING}
  KP_MODE                = 4;    // Mode of the cipher
  {$EXTERNALSYM KP_MODE}
  KP_MODE_BITS           = 5;    // Number of bits to feedback
  {$EXTERNALSYM KP_MODE_BITS}
  KP_PERMISSIONS         = 6;    // Key permissions DWORD
  {$EXTERNALSYM KP_PERMISSIONS}
  KP_ALGID               = 7;    // Key algorithm
  {$EXTERNALSYM KP_ALGID}
  KP_BLOCKLEN            = 8;    // Block size of the cipher
  {$EXTERNALSYM KP_BLOCKLEN}

  { dwFlags definitions for CryptAquireContext }
  CRYPT_VERIFYCONTEXT    = $F0000000;
  {$EXTERNALSYM CRYPT_VERIFYCONTEXT}
  CRYPT_NEWKEYSET        = $00000008;
  {$EXTERNALSYM CRYPT_NEWKEYSET}
  CRYPT_DELETEKEYSET     = $00000010;
  {$EXTERNALSYM CRYPT_DELETEKEYSET}
  CRYPT_MACHINE_KEYSET   = $00000020;
  {$EXTERNALSYM CRYPT_MACHINE_KEYSET}
  CRYPT_SILENT           = $00000040;
  {$EXTERNALSYM CRYPT_SILENT}

function CryptAcquireContext(out hProv: HCRYPTPROV; Container, Provider: PWideChar;
  ProvType, Flags: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptAcquireContext}

function CryptCreateHash(Prov: HCRYPTPROV; Algid: ALG_ID; Key: HCRYPTKEY;
  Flags: DWORD; var Hash: HCRYPTHASH): BOOL; stdcall;
{$EXTERNALSYM CryptCreateHash}

function CryptDecrypt(Key: HCRYPTKEY; Hash: HCRYPTHASH; Final: BOOL;
  Flags: DWORD; pbData: PByte; var pdwDataLen: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptDecrypt}

function CryptDeriveKey(Prov: HCRYPTPROV; Algid: ALG_ID; BaseData: HCRYPTHASH;
  Flags: DWORD; var Key: HCRYPTKEY): BOOL; stdcall;
{$EXTERNALSYM CryptDeriveKey}

function CryptDestroyHash(hHash: HCRYPTHASH): BOOL; stdcall;
{$EXTERNALSYM CryptDestroyHash}

function CryptDestroyKey(hKey: HCRYPTKEY): BOOL; stdcall;
{$EXTERNALSYM CryptDestroyKey}

function CryptDuplicateHash(hHash: HCRYPTHASH; pdwReserved, dwFlags: DWORD;
 var phHash: HCRYPTHASH): BOOL; stdcall;
{$EXTERNALSYM CryptDuplicateHash}

function CryptDuplicateKey(hKey: HCRYPTKEY; pdwReserved, dwFlags: DWORD;
  var phKey: HCRYPTKEY): BOOL; stdcall;
{$EXTERNALSYM CryptDuplicateKey}

function CryptEncrypt(Key: HCRYPTKEY; Hash: HCRYPTHASH; Final: BOOL;
  Flags: LongWord; pbData: PByte; var pdwDataLen, dwBufLen: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptEncrypt}

function CryptGenRandom(hProv: HCRYPTPROV; dwLen: DWORD;
  pbBuffer: PByte): BOOL; stdcall;
{$EXTERNALSYM CryptGenRandom}

function CryptGetHashParam(hHash: HCRYPTHASH; dwParam: DWORD; pbData: PByte;
  var pdwDataLen: DWORD; dwFlags: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptGetHashParam}

function CryptGetKeyParam(hKey: HCRYPTKEY; dwParam: DWORD; var pbData: PByte;
  var pdwDataLen: DWORD; dwFlags: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptGetKeyParam}

const
  { dwParam definitions for CryptGetProvParam }
  PP_CLIENT_HWND         = 1;
  {$EXTERNALSYM PP_CLIENT_HWND}
  PP_ENUMALGS            = 1;
  {$EXTERNALSYM PP_ENUMALGS}
  PP_ENUMCONTAINERS      = 2;
  {$EXTERNALSYM PP_ENUMCONTAINERS}
  PP_IMPTYPE             = 3;
  {$EXTERNALSYM PP_IMPTYPE}
  PP_NAME                = 4;
  {$EXTERNALSYM PP_NAME}
  PP_VERSION             = 5;
  {$EXTERNALSYM PP_VERSION}
  PP_CONTAINER           = 6;
  {$EXTERNALSYM PP_CONTAINER}
  PP_CHANGE_PASSWORD     = 7;
  {$EXTERNALSYM PP_CHANGE_PASSWORD}
  PP_KEYSET_SEC_DESCR    = 8;
  {$EXTERNALSYM PP_KEYSET_SEC_DESCR}
  PP_CERTCHAIN           = 9;
  {$EXTERNALSYM PP_CERTCHAIN}
  PP_KEY_TYPE_SUBTYPE    = 10;
  {$EXTERNALSYM PP_KEY_TYPE_SUBTYPE}
  PP_CONTEXT_INFO        = 11;
  {$EXTERNALSYM PP_CONTEXT_INFO}
  PP_KEYEXCHANGE_KEYSIZE = 12;
  {$EXTERNALSYM PP_KEYEXCHANGE_KEYSIZE}
  PP_SIGNATURE_KEYSIZE   = 13;
  {$EXTERNALSYM PP_SIGNATURE_KEYSIZE}
  PP_KEYEXCHANGE_ALG     = 14;
  {$EXTERNALSYM PP_KEYEXCHANGE_ALG}
  PP_SIGNATURE_ALG       = 15;
  {$EXTERNALSYM PP_SIGNATURE_ALG}
  PP_PROVTYPE            = 16;
  {$EXTERNALSYM PP_PROVTYPE}
  PP_KEYSTORAGE          = 17;
  {$EXTERNALSYM PP_KEYSTORAGE}
  PP_APPLI_CERT          = 18;
  {$EXTERNALSYM PP_APPLI_CERT}
  PP_SYM_KEYSIZE         = 19;
  {$EXTERNALSYM PP_SYM_KEYSIZE}
  PP_SESSION_KEYSIZE     = 20;
  {$EXTERNALSYM PP_SESSION_KEYSIZE}
  PP_UI_PROMPT           = 21;
  {$EXTERNALSYM PP_UI_PROMPT}
  PP_ENUMALGS_EX         = 22;
  {$EXTERNALSYM PP_ENUMALGS_EX}
  PP_DELETEKEY           = 24;
  {$EXTERNALSYM PP_DELETEKEY}
  PP_ENUMMANDROOTS       = 25;
  {$EXTERNALSYM PP_ENUMMANDROOTS}
  PP_ENUMELECTROOTS      = 26;
  {$EXTERNALSYM PP_ENUMELECTROOTS}
  PP_KEYSET_TYPE         = 27;
  {$EXTERNALSYM PP_KEYSET_TYPE}
  PP_ADMIN_PIN           = 31;
  {$EXTERNALSYM PP_ADMIN_PIN}
  PP_KEYEXCHANGE_PIN     = 32;
  {$EXTERNALSYM PP_KEYEXCHANGE_PIN}
  PP_SIGNATURE_PIN       = 33;
  {$EXTERNALSYM PP_SIGNATURE_PIN}
  PP_SIG_KEYSIZE_INC     = 34;
  {$EXTERNALSYM PP_SIG_KEYSIZE_INC}
  PP_KEYX_KEYSIZE_INC    = 35;
  {$EXTERNALSYM PP_KEYX_KEYSIZE_INC}
  PP_UNIQUE_CONTAINER    = 36;
  {$EXTERNALSYM PP_UNIQUE_CONTAINER}
  PP_SGC_INFO            = 37;
  {$EXTERNALSYM PP_SGC_INFO}
  PP_USE_HARDWARE_RNG    = 38;
  {$EXTERNALSYM PP_USE_HARDWARE_RNG}
  PP_KEYSPEC             = 39;
  {$EXTERNALSYM PP_KEYSPEC}
  PP_ENUMEX_SIGNING_PROT = 40;
  {$EXTERNALSYM PP_ENUMEX_SIGNING_PROT}
  PP_CRYPT_COUNT_KEY_USE = 41;
  {$EXTERNALSYM PP_CRYPT_COUNT_KEY_USE}

function CryptGetProvParam(hProv: HCRYPTPROV; dwParam: DWORD; pbData: PByte;
  var pdwDataLen: DWORD; dwFlags: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptGetProvParam}

const
  { dwKeySpec definitions for CryptGetUserKey }
  AT_KEYEXCHANGE        = 1;
  {$EXTERNALSYM AT_KEYEXCHANGE}
  AT_SIGNATURE          = 2;
  {$EXTERNALSYM AT_SIGNATURE}

function CryptGetUserKey(hProv: HCRYPTPROV; dwKeySpec: DWORD;
  var phUserKey: HCRYPTKEY): BOOL; stdcall;
{$EXTERNALSYM CryptGetUserKey}

function CryptHashData(Hash: HCRYPTHASH; Data: PByte; DataLen: LongWord;
  Flags: LongWord): BOOL; stdcall;
{$EXTERNALSYM CryptHashData}

function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: LongWord): BOOL; stdcall;
{$EXTERNALSYM CryptReleaseContext}

function CryptSetHashParam(hHash: HCRYPTHASH; dwParam: DWORD;
  const pbData: PByte; dwFlags: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptSetHashParam}

function CryptSetKeyParam(hKey: HCRYPTKEY; dwParam: DWORD; pbData: PByte;
  dwFlags: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptSetKeyParam}

const
  { dwFlags definitions for Base64 functions }
  CRYPT_STRING_BASE64HEADER        = $00000000;
  {$EXTERNALSYM CRYPT_STRING_BASE64HEADER}
  CRYPT_STRING_BASE64              = $00000001;
  {$EXTERNALSYM CRYPT_STRING_BASE64}
  CRYPT_STRING_BINARY              = $00000002;
  {$EXTERNALSYM CRYPT_STRING_BINARY}
  CRYPT_STRING_BASE64REQUESTHEADER = $00000003;
  {$EXTERNALSYM CRYPT_STRING_BASE64REQUESTHEADER}
  CRYPT_STRING_HEX                 = $00000004;
  {$EXTERNALSYM CRYPT_STRING_HEX}
  CRYPT_STRING_HEXASCII            = $00000005;
  {$EXTERNALSYM CRYPT_STRING_HEXASCII}
  CRYPT_STRING_BASE64_ANY          = $00000006;
  {$EXTERNALSYM CRYPT_STRING_BASE64_ANY}
  CRYPT_STRING_ANY                 = $00000007;
  {$EXTERNALSYM CRYPT_STRING_ANY}
  CRYPT_STRING_HEX_ANY             = $00000008;
  {$EXTERNALSYM CRYPT_STRING_HEX_ANY}
  CRYPT_STRING_BASE64X509CRLHEADER = $00000009;
  {$EXTERNALSYM CRYPT_STRING_BASE64X509CRLHEADER}
  CRYPT_STRING_HEXADDR             = $0000000a;
  {$EXTERNALSYM CRYPT_STRING_HEXADDR}
  CRYPT_STRING_HEXASCIIADDR        = $0000000b;
  {$EXTERNALSYM CRYPT_STRING_HEXASCIIADDR}
  CRYPT_STRING_HEXRAW              = $0000000c;
  {$EXTERNALSYM CRYPT_STRING_HEXRAW}
  CRYPT_STRING_STRICT              = $20000000;
  {$EXTERNALSYM CRYPT_STRING_STRICT}

  CRYPT_STRING_NOCRLF              = $40000000;
  {$EXTERNALSYM CRYPT_STRING_NOCRLF}
  CRYPT_STRING_NOCR                = $80000000;
  {$EXTERNALSYM CRYPT_STRING_NOCR}

function CryptStringToBinary(pszString: PWideChar; cchString, dwFlags: DWORD;
  pbBinary: PByte; var pcbBinary, pdwSkip, pdwFlags: DWORD): Boolean; stdcall;
{$EXTERNALSYM CryptStringToBinary}

function CryptBinaryToString(pbBinary: PByte; cbBinary, dwFlags: DWORD;
  pszString: PWideChar; var pcchString: DWORD): Boolean; stdcall;
{$EXTERNALSYM CryptBinaryToString}

const
  { dwFlag definitions for CryptGenKey }
  CRYPT_EXPORTABLE                 = $00000001;
  {$EXTERNALSYM CRYPT_EXPORTABLE}
  CRYPT_USER_PROTECTED             = $00000002;
  {$EXTERNALSYM CRYPT_USER_PROTECTED}
  CRYPT_CREATE_SALT                = $00000004;
  {$EXTERNALSYM CRYPT_CREATE_SALT}
  CRYPT_UPDATE_KEY                 = $00000008;
  {$EXTERNALSYM CRYPT_UPDATE_KEY}

function CryptGenKey(hProv: HCRYPTPROV; Algid: ALG_ID; dwFlags: DWORD;
  var phKey: HCRYPTKEY): BOOL; stdcall;
{$EXTERNALSYM CryptGenKey}

type
  _CRYPTOAPI_BLOB = record
    cbData: DWORD;
    pbData: PByte;
  end;
  {$EXTERNALSYM _CRYPTOAPI_BLOB}
  CRYPT_INTEGER_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM CRYPT_INTEGER_BLOB}
  PCRYPT_INTEGER_BLOB = ^CRYPT_INTEGER_BLOB;
  {$EXTERNALSYM PCRYPT_INTEGER_BLOB}
  DATA_BLOB = _CRYPTOAPI_BLOB;
  {$EXTERNALSYM DATA_BLOB}
  PDATA_BLOB = ^DATA_BLOB;
  {$EXTERNALSYM PDATA_BLOB}
  TDataBlob = DATA_BLOB;

  _CRYPTPROTECT_PROMPTSTRUCT = record
    cbSize: DWORD;
    dwPromptFlags: DWORD;
    hwndApp: HWND;
    szPrompt: PWideChar;
  end;
  {$EXTERNALSYM _CRYPTPROTECT_PROMPTSTRUCT}
  CRYPTPROTECT_PROMPTSTRUCT = _CRYPTPROTECT_PROMPTSTRUCT;
  {$EXTERNALSYM CRYPTPROTECT_PROMPTSTRUCT}
  PCRYPTPROTECT_PROMPTSTRUCT = ^CRYPTPROTECT_PROMPTSTRUCT;
  {$EXTERNALSYM PCRYPTPROTECT_PROMPTSTRUCT}
  TPromptStruct = CRYPTPROTECT_PROMPTSTRUCT;

const
  { dwFlags definitions for CryptProtectData and CryptUnprotectData }
  CRYPTPROTECT_UI_FORBIDDEN        = $00000001;
  {$EXTERNALSYM CRYPTPROTECT_UI_FORBIDDEN}
  CRYPTPROTECT_PROMPT_ON_PROTECT   = $00000002;
  {$EXTERNALSYM CRYPTPROTECT_PROMPT_ON_PROTECT}
  CRYPTPROTECT_LOCAL_MACHINE       = $00000004;
  {$EXTERNALSYM CRYPTPROTECT_LOCAL_MACHINE}
  CRYPTPROTECT_CRED_SYNC           = $00000008;
  {$EXTERNALSYM CRYPTPROTECT_CRED_SYNC}
  CRYPTPROTECT_AUDIT               = $00000010;
  {$EXTERNALSYM CRYPTPROTECT_AUDIT}
  CRYPTPROTECT_NO_RECOVERY         = $00000020;
  {$EXTERNALSYM CRYPTPROTECT_NO_RECOVERY}
  CRYPTPROTECT_VERIFY_PROTECTION   = $00000040;
  {$EXTERNALSYM CRYPTPROTECT_VERIFY_PROTECTION}

function CryptProtectData(pDataIn: PDATA_BLOB; szDataDescr: PWideChar;
  pOptionalEntropy: PDATA_BLOB; pvReserved: PVOID;
  pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT; dwFlags: DWORD;
  var pDataOut: DATA_BLOB): BOOL; stdcall;
{$EXTERNALSYM CryptProtectData}

function CryptUnprotectData(pDataIn: PDATA_BLOB; ppszDataDescr: PWideChar;
  pOptionalEntropy: PDATA_BLOB; pvReserved: PVOID;
  pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT; dwFlags: DWORD;
  var pDataOut: DATA_BLOB): BOOL; stdcall;
{$EXTERNALSYM CryptUnprotectData}

const
  { dwFlags definitions for CryptProtectMemory and CryptUnprotectMemory }
  CRYPTPROTECTMEMORY_SAME_PROCESS  = $00000000;
  {$EXTERNALSYM CRYPTPROTECTMEMORY_SAME_PROCESS}
  CRYPTPROTECTMEMORY_CROSS_PROCESS = $00000001;
  {$EXTERNALSYM CRYPTPROTECTMEMORY_CROSS_PROCESS}
  CRYPTPROTECTMEMORY_SAME_LOGON    = $00000002;
  {$EXTERNALSYM CRYPTPROTECTMEMORY_SAME_LOGON}
  CRYPTPROTECTMEMORY_BLOCK_SIZE    = $00000010;
  {$EXTERNALSYM CRYPTPROTECTMEMORY_BLOCK_SIZE}

function CryptProtectMemory(var pData: LPVOID; cbData, dwFlags: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptProtectMemory}

function CryptUnProtectMemory(var pData: LPVOID; cbData, dwFlags: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptUnProtectMemory}

const
  { OID key type }
  CRYPT_OID_INFO_OID_KEY           = 1;
  {$EXTERNALSYM CRYPT_OID_INFO_OID_KEY}
  CRYPT_OID_INFO_NAME_KEY          = 2;
  {$EXTERNALSYM CRYPT_OID_INFO_NAME_KEY}
  CRYPT_OID_INFO_ALGID_KEY         = 3;
  {$EXTERNALSYM CRYPT_OID_INFO_ALGID_KEY}
  CRYPT_OID_INFO_SIGN_KEY          = 4;
  {$EXTERNALSYM CRYPT_OID_INFO_SIGN_KEY}

{ Possible flags for CryptSignHash() and CryptVerifySignature() }
const
  CRYPT_NOHASHOID                  = 1;
  {$EXTERNALSYM CRYPT_NOHASHOID}
  CRYPT_X931_FORMAT                = 4;
  {$EXTERNALSYM CRYPT_X931_FORMAT}

function CryptSignHash(hHash: HCRYPTHASH; dwKeySpec: DWORD; sDescription: LPCWSTR;
  dwFlags: DWORD; out pbSignature: PByte; var pdwSigLen: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptSignHash}

function CryptVerifySignature(hHash: HCRYPTHASH; pbSignature: PByte; dwSigLen: DWORD;
  hPubKey: HCRYPTKEY; sDescription: LPCWSTR; dwFlags: DWORD): BOOL; stdcall;
{$EXTERNALSYM CryptVerifySignature}

implementation

function CryptAcquireContext; stdcall; external advapi32 name 'CryptAcquireContextW';
function CryptBinaryToString; stdcall; external crypt32 name 'CryptBinaryToStringW';
function CryptCreateHash; stdcall; external advapi32 name 'CryptCreateHash';
function CryptDecrypt; stdcall; external advapi32 name 'CryptDecrypt';
function CryptDeriveKey; stdcall; external advapi32 name 'CryptDeriveKey';
function CryptDestroyHash; stdcall; external advapi32 name 'CryptDestroyHash';
function CryptDestroyKey; stdcall; external advapi32 name 'CryptDestroyKey';
function CryptDuplicateHash; stdcall; external advapi32 name 'CryptDestroyKey';
function CryptDuplicateKey; stdcall; external advapi32 name 'CryptDuplicateKey';
function CryptEncrypt; stdcall; external advapi32 name 'CryptEncrypt';
function CryptGenKey; stdcall; external advapi32 name 'CryptGenKey';
function CryptGenRandom; stdcall; external advapi32 name 'CryptGenRandom';
function CryptGetHashParam; stdcall; external advapi32 name 'CryptGetHashParam';
function CryptGetKeyParam; stdcall; external advapi32 name 'CryptGetKeyParam';
function CryptGetProvParam; stdcall; external advapi32 name 'CryptGetProvParam';
function CryptGetUserKey; stdcall; external advapi32 name 'CryptGetUserKey';
function CryptHashData; stdcall; external advapi32 name 'CryptHashData';
function CryptReleaseContext; stdcall; external advapi32 name 'CryptReleaseContext';
function CryptSetHashParam; stdcall; external advapi32 name 'CryptSetHashParam';
function CryptSetKeyParam; stdcall; external advapi32 name 'CryptSetKeyParam';
function CryptSignHash; stdcall; external crypt32 name 'CryptSignHashW';
function CryptStringToBinary; stdcall; external crypt32 name 'CryptStringToBinaryW';
function CryptProtectData; stdcall; external crypt32 name 'CryptProtectData';
function CryptProtectMemory; stdcall; external crypt32 name 'CryptProtectMemory';
function CryptUnprotectData; stdcall; external crypt32 name 'CryptUnprotectData';
function CryptUnProtectMemory; stdcall; external crypt32 name 'CryptUnProtectMemory';
function CryptVerifySignature; stdcall; external advapi32 name 'CryptVerifySignatureW';

end.

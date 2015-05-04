{ *********************************************************************** }
{                                                                         }
{ Windows CryptAPI Unit                                                   }
{                                                                         }
{ Copyright (c) 2011-2015 Philipp Meisberger (PM Code Works)              }
{                                                                         }
{ *********************************************************************** }

unit CryptAPI;

interface

uses
  Windows;

type
  ALG_ID     = Cardinal;
  HCRYPTPROV = HWND;
  HCRYPTKEY  = HWND;
  HCRYPTHASH = HWND;
  PVOID      = Pointer;
  LPVOID     = Pointer;

  _HMAC_INFO = record
    HashAlgId: ALG_ID;
    pbInnerString: PByte;
    cbInnerString: DWORD;
    pbOuterString: PByte;
    cbOuterString: DWORD;
  end;

  HMAC_INFO = _HMAC_INFO;
  PHMAC_INFO = ^HMAC_INFO;
  THMacInfo = HMAC_INFO;

const
  crypt32                = 'Crypt32.dll';

  { ProviderType }
  PROV_RSA_FULL          = 1;
  PROV_RSA_SIG           = 2;
  PROV_DSS               = 3;
  PROV_FORTEZZA          = 4;
  PROV_MS_EXCHANGE       = 5;
  PROV_SSL               = 6;
  PROV_RSA_SCHANNEL      = 12;
  PROV_DSS_DH            = 13;
  PROV_EC_ECDSA_SIG      = 14;
  PROV_EC_ECNRA_SIG      = 15;
  PROV_EC_ECDSA_FULL     = 16;
  PROV_EC_ECNRA_FULL     = 17;
  PROV_DH_SCHANNEL       = 18;
  PROV_SPYRUS_LYNKS      = 20;
  PROV_RNG               = 21;
  PROV_INTEL_SEC         = 22;
  PROV_REPLACE_OWF       = 23;
  PROV_RSA_AES           = 24;

  { Algorithm classes }
  ALG_CLASS_ANY          = 0;
  ALG_CLASS_SIGNATURE    = 1 shl 13;
  ALG_CLASS_MSG_ENCRYPT  = 2 shl 13;
  ALG_CLASS_DATA_ENCRYPT = 3 shl 13;
  ALG_CLASS_HASH         = 4 shl 13;
  ALG_CLASS_KEY_EXCHANGE = 5 shl 13;
  ALG_CLASS_ALL          = 7 shl 13;

  { Algorithm types }
  ALG_TYPE_ANY           = 0;
  ALG_TYPE_DSS           = 1 shl 9;
  ALG_TYPE_RSA           = 2 shl 9;
  ALG_TYPE_BLOCK         = 3 shl 9;
  ALG_TYPE_STREAM        = 4 shl 9;
  ALG_TYPE_DH            = 5 shl 9;
  ALG_TYPE_SECURECHANNEL = 6 shl 9;

  { Hash algorithm identifiers }
  ALG_SID_MD5            = 3;
  ALG_SID_SHA            = 4;
  ALG_SID_SHA1           = 4;
  ALG_SID_MAC            = 5;
  ALG_SID_HMAC           = 9;
  ALG_SID_SHA_256        = 12;
  ALG_SID_SHA_384        = 13;
  ALG_SID_SHA_512        = 14;

  { Advanced Encryption Standard (AES) algorithm identifiers }
  ALG_SID_AES            = 17;
  ALG_SID_AES_128        = 14;
  ALG_SID_AES_192        = 15;
  ALG_SID_AES_256        = 16;

  { Diffie-Hellman algorithm identifiers }
  ALG_SID_DH_SANDF       = 1;
  ALG_SID_DH_EPHEM       = 2;
  ALG_SID_AGREED_KEY_ANY = 3;
  ALG_SID_KEA            = 4;

  { Advanced Encryption Standard (AES) algorithm }
  CALG_AES               = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES);
  CALG_AES_128           = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES_128);
  CALG_AES_192           = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES_192);
  CALG_AES_256           = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES_256);

  { Cipher algorithm modes }
  CRYPT_MODE_CBC         = 1;    // Cipher block chaining
  CRYPT_MODE_ECB         = 2;    // Electronic code book
  CRYPT_MODE_OFB         = 3;    // Output feedback mode
  CRYPT_MODE_CFB         = 4;    // Cipher feedback mode
  CRYPT_MODE_CTS         = 5;    // Ciphertext stealing mode

  { Deprecated hashing algorithms }
  CALG_MD5               = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD5);
  CALG_SHA               = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA);
  CALG_SHA_160           = CALG_SHA;

  { Message authentication code algorithms }
  CALG_MAC               = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MAC);
  CALG_HMAC              = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_HMAC);

  { SHA-2 hashing algorithm }
  CALG_SHA_256           = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA_256);
  CALG_SHA_384           = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA_384);
  CALG_SHA_512           = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA_512);

  { Diffie-Hellman algorithm }
  CALG_DH_SF             = (ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_DH_SANDF);
  CALG_DH_EPHEM          = (ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_DH_EPHEM);

  { Hash algorithm flags }
  HP_ALGID               = $00000001;
  HP_HASHVAL             = $00000002;
  HP_HASHSIZE            = $00000004;
  HP_HMAC_INFO           = $00000005;
  HP_TLS1PRF_LABEL       = $00000006;
  HP_TLS1PRF_SEED        = $00000007;

  { dwParam }
  KP_IV                  = 1;    // Initialization vector
  KP_SALT                = 2;    // Salt value
  KP_PADDING             = 3;    // Padding values
  KP_MODE                = 4;    // Mode of the cipher
  KP_MODE_BITS           = 5;    // Number of bits to feedback
  KP_PERMISSIONS         = 6;    // Key permissions DWORD
  KP_ALGID               = 7;    // Key algorithm
  KP_BLOCKLEN            = 8;    // Block size of the cipher

  { dwFlags definitions for CryptAquireContext }
  CRYPT_VERIFYCONTEXT    = $F0000000;
  CRYPT_NEWKEYSET        = $00000008;
  CRYPT_DELETEKEYSET     = $00000010;
  CRYPT_MACHINE_KEYSET   = $00000020;
  CRYPT_SILENT           = $00000040;

function CryptAcquireContext(var hProv: HCRYPTPROV; Container, Provider: PChar;
  ProvType: LongWord; Flags: LongWord): LongBool; stdcall;
function CryptAcquireContextA(var hProv: HCRYPTPROV; Container, Provider: PAnsiChar;
  ProvType: LongWord; Flags: LongWord): LongBool; stdcall;
function CryptAcquireContextW(var hProv: HCRYPTPROV; Container, Provider: PWideChar;
  ProvType: LongWord; Flags: LongWord): LongBool; stdcall;
function CryptCreateHash(Prov: HCRYPTPROV; Algid: ALG_ID; Key: HCRYPTKEY;
  Flags: LongWord; var Hash: HCRYPTHASH): LongBool; stdcall;
function CryptDecrypt(Key: HCRYPTKEY; Hash: HCRYPTHASH; Final: LongBool;
  Flags: LongWord; pbData: PByte; var pdwDataLen: DWORD): LongBool; stdcall;
function CryptDeriveKey(Prov: HCRYPTPROV; Algid: ALG_ID; BaseData: HCRYPTHASH;
  Flags: LongWord; var Key: HCRYPTKEY): LongBool; stdcall;
function CryptDestroyHash(hHash: HCRYPTHASH): LongBool; stdcall;
function CryptDestroyKey(hKey: HCRYPTKEY): LongBool; stdcall;
function CryptDuplicateHash(hHash: HCRYPTHASH; pdwReserved, dwFlags: DWORD;
 var phHash: HCRYPTHASH): LongBool; stdcall;
function CryptDuplicateKey(hKey: HCRYPTKEY; pdwReserved, dwFlags: DWORD;
  var phKey: HCRYPTKEY): LongBool; stdcall;
function CryptEncrypt(Key: HCRYPTKEY; Hash: HCRYPTHASH; Final: LongBool;
  Flags: LongWord; pbData: PByte; var pdwDataLen, dwBufLen: DWORD): LongBool; stdcall;
function CryptGenRandom(hProv: HCRYPTPROV; dwLen: DWORD;
  var pbBuffer: PByte): LongBool; stdcall;
function CryptGetHashParam(hHash: HCRYPTHASH; dwParam: DWORD; pbData: PByte;
  var pdwDataLen: DWORD; dwFlags: DWORD): LongBool; stdcall;
function CryptGetKeyParam(hKey: HCRYPTKEY; dwParam: DWORD; var pbData: PByte;
  var pdwDataLen: DWORD; dwFlags: DWORD): LongBool; stdcall;

const
  { dwParam definitions for CryptGetProvParam }
  PP_CLIENT_HWND         = 1;
  PP_ENUMALGS            = 1;
  PP_ENUMCONTAINERS      = 2;
  PP_IMPTYPE             = 3;
  PP_NAME                = 4;
  PP_VERSION             = 5;
  PP_CONTAINER           = 6;
  PP_CHANGE_PASSWORD     = 7;
  PP_KEYSET_SEC_DESCR    = 8;
  PP_CERTCHAIN           = 9;
  PP_KEY_TYPE_SUBTYPE    = 10;
  PP_CONTEXT_INFO        = 11;
  PP_KEYEXCHANGE_KEYSIZE = 12;
  PP_SIGNATURE_KEYSIZE   = 13;
  PP_KEYEXCHANGE_ALG     = 14;
  PP_SIGNATURE_ALG       = 15;
  PP_PROVTYPE            = 16;
  PP_KEYSTORAGE          = 17;
  PP_APPLI_CERT          = 18;
  PP_SYM_KEYSIZE         = 19;
  PP_SESSION_KEYSIZE     = 20;
  PP_UI_PROMPT           = 21;
  PP_ENUMALGS_EX         = 22;
  PP_DELETEKEY           = 24;
  PP_ENUMMANDROOTS       = 25;
  PP_ENUMELECTROOTS      = 26;
  PP_KEYSET_TYPE         = 27;
  PP_ADMIN_PIN           = 31;
  PP_KEYEXCHANGE_PIN     = 32;
  PP_SIGNATURE_PIN       = 33;
  PP_SIG_KEYSIZE_INC     = 34;
  PP_KEYX_KEYSIZE_INC    = 35;
  PP_UNIQUE_CONTAINER    = 36;
  PP_SGC_INFO            = 37;
  PP_USE_HARDWARE_RNG    = 38;
  PP_KEYSPEC             = 39;
  PP_ENUMEX_SIGNING_PROT = 40;
  PP_CRYPT_COUNT_KEY_USE = 41;

function CryptGetProvParam(hProv: HCRYPTPROV; dwParam: DWORD; pbData: PByte;
  var pdwDataLen: DWORD; dwFlags: DWORD): LongBool; stdcall;

const
  { dwKeySpec definitions for CryptGetUserKey }
  AT_KEYEXCHANGE        = 1;
  AT_SIGNATURE          = 2;

function CryptGetUserKey(hProv: HCRYPTPROV; dwKeySpec: DWORD;
  var phUserKey: HCRYPTKEY): LongBool; stdcall;
function CryptHashData(Hash: HCRYPTHASH; Data: PChar; DataLen: LongWord;
  Flags: LongWord): LongBool; stdcall;
function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: LongWord): LongBool; stdcall;
function CryptSetHashParam(hHash: HCRYPTHASH; dwParam: DWORD;
  const pbData: PByte; dwFlags: DWORD): LongBool; stdcall;
function CryptSetKeyParam(hKey: HCRYPTKEY; dwParam: DWORD; pbData: PByte;
  dwFlags: DWORD): LongBool; stdcall;

const
  { dwFlags definitions for Base64 functions }
  CRYPT_STRING_BASE64HEADER        = 0;
  CRYPT_STRING_BASE64              = 1;
  CRYPT_STRING_BINARY              = 2;
  CRYPT_STRING_BASE64REQUESTHEADER = 3;
  CRYPT_STRING_HEX                 = 4;
  CRYPT_STRING_HEXASCII            = 5;
  CRYPT_STRING_BASE64_ANY          = 6;
  CRYPT_STRING_ANY                 = 7;
  CRYPT_STRING_HEX_ANY             = 8;
  CRYPT_STRING_BASE64X509CRLHEADER = 9;
  CRYPT_STRING_HEXADDR             = 10;
  CRYPT_STRING_HEXASCIIADDR        = 11;
  CRYPT_STRING_HEXRAW              = 12;

function CryptStringToBinary(pszString: PChar; cchString, dwFlags: DWORD;
  pbBinary: PByte; var pcbBinary, pdwSkip, pdwFlags: DWORD): Boolean; stdcall;
function CryptStringToBinaryA(pszString: PAnsiChar; cchString, dwFlags: DWORD;
  pbBinary: PByte; var pcbBinary, pdwSkip, pdwFlags: DWORD): Boolean; stdcall;
function CryptStringToBinaryW(pszString: PWideChar; cchString, dwFlags: DWORD;
  pbBinary: PByte; var pcbBinary, pdwSkip, pdwFlags: DWORD): Boolean; stdcall;
function CryptBinaryToString(pbBinary: Pointer; cbBinary, dwFlags: DWORD;
  pszString: PChar; var pcchString: DWORD): Boolean; stdcall;
function CryptBinaryToStringA(pbBinary: Pointer; cbBinary: DWORD; dwFlags: DWORD;
  pszString: PAnsiChar; var pcchString: DWORD): Boolean; stdcall;
function CryptBinaryToStringW(pbBinary: Pointer; cbBinary, dwFlags: DWORD;
  pszString: PWideChar; var pcchString: DWORD): Boolean; stdcall;

const
  { dwFlag definitions for CryptGenKey }
  CRYPT_EXPORTABLE                 = $00000001;
  CRYPT_USER_PROTECTED             = $00000002;
  CRYPT_CREATE_SALT                = $00000004;
  CRYPT_UPDATE_KEY                 = $00000008;

function CryptGenKey(hProv: HCRYPTPROV; Algid: ALG_ID; dwFlags: DWORD;
  var phKey: HCRYPTKEY): LongBool; stdcall;

type
  _CRYPTOAPI_BLOB = record
    cbData: DWORD;
    pbData: PByte;
  end;

  CRYPT_INTEGER_BLOB = _CRYPTOAPI_BLOB;
  PCRYPT_INTEGER_BLOB = ^CRYPT_INTEGER_BLOB;
  DATA_BLOB = _CRYPTOAPI_BLOB;
  PDATA_BLOB = ^DATA_BLOB;
  TDataBlob = DATA_BLOB;

  _CRYPTPROTECT_PROMPTSTRUCT = record
    cbSize: DWORD;
    dwPromptFlags: DWORD;
    hwndApp: HWND;
    szPrompt: PWideChar;
  end;

  CRYPTPROTECT_PROMPTSTRUCT = _CRYPTPROTECT_PROMPTSTRUCT;
  PCRYPTPROTECT_PROMPTSTRUCT = ^CRYPTPROTECT_PROMPTSTRUCT;
  TPromptStruct = CRYPTPROTECT_PROMPTSTRUCT;

const
  { dwFlags definitions for CryptProtectData and CryptUnprotectData }
  CRYPTPROTECT_UI_FORBIDDEN        = $00000001;
  CRYPTPROTECT_PROMPT_ON_PROTECT   = $00000002;
  CRYPTPROTECT_LOCAL_MACHINE       = $00000004;
  CRYPTPROTECT_CRED_SYNC           = $00000008;
  CRYPTPROTECT_AUDIT               = $00000010;
  CRYPTPROTECT_NO_RECOVERY         = $00000020;
  CRYPTPROTECT_VERIFY_PROTECTION   = $00000040;

function CryptProtectData(pDataIn: PDATA_BLOB; szDataDescr: PWideChar;
  pOptionalEntropy: PDATA_BLOB; pvReserved: PVOID;
  pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT; dwFlags: DWORD;
  var pDataOut: DATA_BLOB): LongBool; stdcall;
function CryptUnprotectData(pDataIn: PDATA_BLOB; ppszDataDescr: PWideChar;
  pOptionalEntropy: PDATA_BLOB; pvReserved: PVOID;
  pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT; dwFlags: DWORD;
  var pDataOut: DATA_BLOB): LongBool; stdcall;

const
  { dwFlags definitions for CryptProtectMemory and CryptUnprotectMemory }
  CRYPTPROTECTMEMORY_SAME_PROCESS  = $00000000;
  CRYPTPROTECTMEMORY_CROSS_PROCESS = $00000001;
  CRYPTPROTECTMEMORY_SAME_LOGON    = $00000002;
  CRYPTPROTECTMEMORY_BLOCK_SIZE    = $00000010;

function CryptProtectMemory(var pData: LPVOID; cbData, dwFlags: DWORD): LongBool; stdcall;
function CryptUnProtectMemory(var pData: LPVOID; cbData, dwFlags: DWORD): LongBool; stdcall;

const
  { OID key type }
  CRYPT_OID_INFO_OID_KEY           = 1;
  CRYPT_OID_INFO_NAME_KEY          = 2;
  CRYPT_OID_INFO_ALGID_KEY         = 3;
  CRYPT_OID_INFO_SIGN_KEY          = 4;

implementation

function CryptAcquireContext; stdcall; external advapi32 name 'CryptAcquireContextA';
function CryptAcquireContextA; stdcall; external advapi32 name 'CryptAcquireContextA';
function CryptAcquireContextW; stdcall; external advapi32 name 'CryptAcquireContextW';
function CryptBinaryToString; stdcall; external Crypt32 name 'CryptBinaryToStringA';
function CryptBinaryToStringA; stdcall; external crypt32 name 'CryptBinaryToStringA';
function CryptBinaryToStringW; stdcall; external crypt32 name 'CryptBinaryToStringW';
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
function CryptStringToBinary; stdcall; external Crypt32 name 'CryptStringToBinaryA';
function CryptStringToBinaryA; stdcall; external crypt32 name 'CryptStringToBinaryA';
function CryptStringToBinaryW; stdcall; external crypt32 name 'CryptStringToBinaryW';
function CryptProtectData; stdcall; external crypt32 name 'CryptProtectData';
function CryptProtectMemory; stdcall; external crypt32 name 'CryptProtectMemory';
function CryptUnprotectData; stdcall; external crypt32 name 'CryptUnprotectData';
function CryptUnProtectMemory; stdcall; external crypt32 name 'CryptUnProtectMemory';

end.

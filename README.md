# Nim DLL Sideloading

This repo allows you to easily generate Nim DLLs you can use sideloading/proxy loading.
If you're unfamiliar with what DLL sideloading is, take a gander at [this blog post](https://redteaming.co.uk/2020/07/12/dll-proxy-loading-your-favorite-c-implant/).

## How do I use this?

Put the legit DLL (or multiple DLLs) you want to proxy into the `build` directory of this repo then run `make`.

This will generate two `.dll`s in the `out` directory:
- The randomly named one is the original DLL that function calls will be proxied too
- The other will be your payload

If sideloading is successful, you should see a message box popup and/or a file written to the desktop.

To actually "weaponize" the payload, you can take a look at the [OffensiveNim](https://github.com/byt3bl33d3r/OffensiveNim) repository for ideas and ready-to-go code snippets :). 

## How does it work?

- `dllproxy.nim` is the proxy DLL that will execute your payload and proxy legit function calls to the original DLL(s)
- `gen_def.py` parses the original DLL's export table and generates a [Module-definition (`.def`) file](https://learn.microsoft.com/en-us/cpp/build/reference/module-definition-dot-def-files?view=msvc-170).

The `.def` file then gets passed to the linker at compile time in order to proxy the legit function calls.

## Bonus - Hide `NimMain` from a Nim DLL's export table

See this [Microsoft article](https://learn.microsoft.com/en-us/cpp/build/reference/exports?view=msvc-170)

Notice the last line of this `.def` file:

```
EXPORTS
	GetFileVersionInfoA=ZCnerzNI.GetFileVersionInfoA @1
	GetFileVersionInfoByHandle=ZCnerzNI.GetFileVersionInfoByHandle @2
	GetFileVersionInfoExA=ZCnerzNI.GetFileVersionInfoExA @3
	GetFileVersionInfoExW=ZCnerzNI.GetFileVersionInfoExW @4
	GetFileVersionInfoSizeA=ZCnerzNI.GetFileVersionInfoSizeA @5
	GetFileVersionInfoSizeExA=ZCnerzNI.GetFileVersionInfoSizeExA @6
	GetFileVersionInfoSizeExW=ZCnerzNI.GetFileVersionInfoSizeExW @7
	GetFileVersionInfoSizeW=ZCnerzNI.GetFileVersionInfoSizeW @8
	GetFileVersionInfoW=ZCnerzNI.GetFileVersionInfoW @9
	VerFindFileA=ZCnerzNI.VerFindFileA @10
	VerFindFileW=ZCnerzNI.VerFindFileW @11
	VerInstallFileA=ZCnerzNI.VerInstallFileA @12
	VerInstallFileW=ZCnerzNI.VerInstallFileW @13
	VerLanguageNameA=ZCnerzNI.VerLanguageNameA @14
	VerLanguageNameW=ZCnerzNI.VerLanguageNameW @15
	VerQueryValueA=ZCnerzNI.VerQueryValueA @16
	VerQueryValueW=ZCnerzNI.VerQueryValueW @17
	NimMain @19 NONAME PRIVATE
```

This last line basically tells the linker to remove the name of the `NimMain` function. Compiling the DLL and passing the above `.def` file to the linker results in the following entry if we take a look at the `.dll`'s export table: 

![HiddenNimMain](https://user-images.githubusercontent.com/5151193/205427811-01e4e941-f79f-40c8-b96d-eb3292200410.png)
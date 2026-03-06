if exists("b:current_syntax")
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

syn keyword zencKeyword
    \ alias
    \ as
    \ asm
    \ async
    \ autofree
    \ await
    \ break
    \ comptime
    \ const
    \ continue
    \ def
    \ defer
    \ else
    \ embed
    \ enum
    \ eprint
    \ eprintln
    \ extern
    \ fn
    \ for
    \ guard
    \ if
    \ impl
    \ import
    \ in
    \ launch
    \ let
    \ loop
    \ match
    \ opaque
    \ plugin
    \ print
    \ println
    \ raw
    \ ref
    \ return
    \ struct
    \ test
    \ trait
    \ union
    \ unless
    \ use
    \ volatile
    \ while
    \ with

" These are keywords in C but not Zen C. They are included here to provide
" better highlighting in `raw` blocks.
syn keyword zencKeyword
    \ _Alignas
    \ _Alignof
    \ _Atomic
    \ _BitInt
    \ _Generic
    \ _Noreturn
    \ _Static_assert
    \ _Thread_local
    \ alignas
    \ alignof
    \ auto
    \ case
    \ constexpr
    \ default
    \ do
    \ goto
    \ inline
    \ register
    \ restrict
    \ static
    \ static_assert
    \ switch
    \ thread_local
    \ typedef
    \ typeof
    \ typeof_unequal

" Currently, only built-in types will be highlighted (including built-in C
" types).
" If we wanted to properly support highlighting of custom types in all
" contexts in which they occur, that would complicate this plugin quite a bit.
" That functionality is more within the purview of a proper parser like
" Treesitter.
syn keyword zencType
    \ _Bool
    \ _Complex
    \ _Decimal128
    \ _Decimal32
    \ _Decimal64
    \ _Imaginary
    \ bool
    \ byte
    \ c_char c_uchar
    \ c_short c_ushort
    \ c_int c_unit
    \ c_long c_ulong
    \ char
    \ double
    \ F32 F64
    \ f32 f64
    \ float
    \ I8 I16 I32 I64 I128
    \ i8 i16 i32 i64 i128
    \ int
    \ int8_t int16_t int32_t int64_t
    \ int_fast8_t int_fast16_t int_fast32_t int_fast64_t
    \ int_least8_t int_least16_t int_least32_t int_least64_t
    \ intmax_t
    \ intptr_t
    \ isize
    \ long
    \ max_align_t
    \ nullptr_t
    \ ptrdiff_t
    \ short
    \ signed
    \ size_t
    \ string
    \ U0
    \ U8 U16 U32 U64 U128
    \ u0
    \ u8 u16 u32 u64 u128
    \ uint
    \ uint8_t uint16_t uint32_t uint64_t
    \ uint_fast8_t uint_fast16_t uint_fast32_t uint_fast64_t
    \ uint_least8_t uint_least16_t uint_least32_t uint_least64_t
    \ uintmax_t
    \ uintptr_t
    \ usize
    \ unsigned
    \ void

syn keyword zencConstant
    \ NULL
    \ false
    \ nullptr
    \ true

syn match zencOperator /\v(\<\=|\>\=|\=\=|!\=|\=|\.|\+|-|\*|\/|\%|\<|\>|\&|\||\^|!|\~|\[|\])/

syn match zencGenericOperator contained /\v\*/

syn match zencDelimiter /\v(-\>|;|:|\(|\)|,|\{|\})/

syn match zencGenericDelimiter contained /\v[\<,\>]/

" The main reason this region match even exists is to prevent zencFunctionName
" from matching inside of a generic type specifier.
" For now, generic type specifier regions are limited to one line (multiline
" may get a bit complicated due to clashes with the greater than and less than
" operators).
syn region zencGenericTypeSpec
    \ oneline
    \ keepend
    \ contains=zencType,zencGenericOperator,zencGenericDelimiter,zencGenericTypeSpec
    \ start=/\v\<\s*/
    \ end=/\v\s*\>/

syn region zencString oneline start=/"/ skip=/\\"/ end=/"/

syn region zencContainedString contained oneline start=/"/ skip=/\\"/ end=/"/

syn region zencAngleString contained oneline start=/</ end=/>/

" decimal int literal
syn match zencNumber /\v\c[1-9][0-9]*([iu]128|llu|ull|[iu](16|32|64)|ll|lu|ul|[iu]8|l|u)?/

" octal int literal
syn match zencNumber /\v\c0[0-7]*([iu]128|llu|ull|[iu](16|32|64)|ll|lu|ul|[iu]8|l|u)?/

" hex int literal
syn match zencNumber /\v\c0x[0-9a-f]+([iu]128|llu|ull|[iu](16|32|64)|ll|lu|ul|[iu]8|l|u)?/

" binary int literal
syn match zencNumber /\v\c0b[01]+([iu]128|llu|ull|[iu](16|32|64)|ll|lu|ul|[iu]8|l|u)?/

" decimal float literal (including scientific notation)
syn match zencNumber /\v\c((\d+\.?\d*|\d*\.?\d+)e-?\d+|\d+\.\d*|\d*\.\d+)(f(32|64)|f|l)?/

" hex float literal (including scientific notation)
syn match zencNumber /\v\c0x([0-9a-f]+\.?[0-9a-f]*|[0-9a-f]*\.?[0-9a-f]+)p-?\d+(f(32|64)|f|l)?/

" These matches prevent the periods in 0..10 from being highlighted as a float
syn match zencNumber /\v\d+\ze\.\./
syn match zencOperator /\v\.\./

" This match exists solely to prevent identifiers with numbers in them from
" being highlighted as numbers. This syntax group is intentionally not linked
" with Identifier in order to more closely match the syntax highlighting
" provided for other languages.
syn match zencIdentifier /\v[A-Za-z_]\w*/

" This will highlight both generic and non generic function names.
syn match zencFunctionName /\v[A-Za-z_]\w*\ze(\<[0-9A-Za-z_, \t\<\>\*]+\>)?\(/

syn match zencDecorator /\v\@\w+/

syn match zencEllipsis /\v\.\.\./

syn region zencMacro
    \ contains=zencContainedString
    \ start=/\v^\s*#/
    \ skip=/\\$/
    \ end=/\v\ze(\/\/.*|\/\*.*)?$/

" Special coloring for filename strings in include macros
syn match zencMacro contains=zencContainedString,zencAngleString /\v^\s*#\s*include\s+[<"].+[>"]/

" Special coloring for filename strings in include statments
syn match zencKeyword contains=zencContainedString,zencAngleString /\v^\s*include\s+[<"].+[>"]/

" Single-line comments
syn match zencComment /\v\/\/.*$/

" Multi-line comments
syn region zencComment start=/\v\/\*/ end=/\v\*\//

" Fixes comment highlighting when scrolling buffer with <C-e>.
syn sync ccomment zencComment

hi def link zencKeyword Statement
hi def link zencType Type
hi def link zencConstant Constant
hi def link zencOperator Operator
hi def link zencGenericOperator Operator
hi def link zencDelimiter Delimiter
hi def link zencGenericDelimiter Delimiter
hi def link zencString String
hi def link zencContainedString String
hi def link zencAngleString String
hi def link zencNumber Number
hi def link zencFunctionName Function
hi def link zencDecorator Statement
hi def link zencEllipsis Special
hi def link zencMacro Constant
hi def link zencInclude Statement
hi def link zencComment Comment

let b:current_syntax = "zenc"

let &cpo = s:save_cpo
unlet s:save_cpo

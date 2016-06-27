# Chapter 1 - Starting Off

## Mathematical operators for integers

The usual left-associative order, `*`, `/` and 'mod' have higher precedence than others.

| operator | Description |
|----------|-------------|
| a + b | addition |
| a - b | subtraction |
| a * b | multiplication |
| a / b | division |
| a mod b | mod |

## Booleans

Usual `true` and `false`.

## Comparison operators

| operator | Description | Ocaml |
|----------|-------------| -----|
| a == b | true if equal | a = b |
| a < b | true if a less than b | a < b |
| a <= b | true if a less than or equal to b | a <= b |
| a > b | true if a greater than b | a > b |
| a >= b | true if a greater than or equal to than b | a >= b |
| a != b | true if a not equal to b | a <> b |

## boolean combination operators

`&&` and `||`

## Chars

```reason
Reason # 'c'
- : char = 'c'
```

## Conditional expressions

```ocaml
# if 100 > 99 then 0 else 1;;
- : int = 0
```

```reason
Reason # if (100 > 99) {0} else {1};
- : int = 0
```

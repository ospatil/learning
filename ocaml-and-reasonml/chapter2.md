# Chapter 2 - Names and Functions

+ Let binding

  + Single expression

    ```ocaml
    # let x = 200 in x * x * x;;
    - : int = 8000000
    ```

    ```reason
    Reason # {let x = 200; x * x * x};
    - : int = 8000000
    ```

  + Function

    ```ocaml
    # let cube x = x * x * x;;
    val cube : int -> int = <fun>
    ```

    ```reason
    Reason # let cube = fun x => x * x * x;
    let cube : int => int = <fun>                                                                                           Reason # cube 200;
    - : int = 8000000
    ```

    ```ocaml
    # let isvowel c =
        c = 'a' || c = 'e' || c = 'i' || c = 'o' || c = 'u';;
    val isvowel : char -> bool = <fun>
    # isvowel 'a';;
    - : bool = true
    # isvowel 'b';;
    - : bool = false
    ```

    ```reason
    Reason # let isvowel = fun c =>
    c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u';
    _none_let isvowel : char => bool = <fun>                                                                                Reason # isvowel 'a';
    - : bool = true                                                                                                         Reason # isvowel 'b';
    - : bool = false
    ```

  + Multiple arguments

    ```ocaml
    # let addtoten a b =
  	a + b = 10;;
    val addtoten : int -> int -> bool = <fun>
    # addtoten 4 5;;
    - : bool = false
    # addtoten 4 6;;
    - : bool = true
    ```

    ```reason
    Reason # let addtoten = fun (a, b) =>
    a + b == 10;
    _none_let addtoten : (int, int) => bool = <fun>
    Reason # addtoten (4,5);
    - : bool = false                                                                                                        Reason # addtoten (5,5);
    - : bool = true
    ```

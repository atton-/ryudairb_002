Ryudai.rb #2


## ソースとかなんとか
[github](https://github.com/atton-/ryudairb_002)にあります

## あじぇんだ
* プロックとブロック (Proc and Block)
* Iterator
* Block を取るメソッド
* each とかを書いてみよう


## あらすじ
次回発表して、とのことで間に受けてネタが無い無いしてると
`@innparusu` さんが「ブロックを取るメソッドってありましたよね」って言ってくれたのでそれでいきます。
ちょっと怪しいところありますがその辺はツッコんでやってください


## プロック と ブロック (Proc and Block)
Ruby には Proc というものがあります。
一言で言えば多分 `lambda` 。手続きを持つオブジェクトのことです。

> たぶん。 詳しい人から見ると違いがあるのかもしれませんがその辺分かる人いたらむしろ教えてください。

Ruby だと do ... end や { ... } な `Block` がそのまま `Proc` と対応してたりします

> なので「 Block と Proc だぜ!」みたいな感じもあるとか無いとか

ちなみにプロックはこういうやつ。 引数を取ることもできますし、変数にも入れられるのので持ち運びもできます。
その proc を `Proc.call` で Proc の処理を呼ぶことができます。
引数も `Proc.call`に渡せば良いです

> ちなみに Proc の引数を `Proc.curry` でカリー化もできたり

``` Ruby:proc.rb
my_proc = Proc.new do |item|
  puts item
end

my_proc.call 1
# => 1 
```

それでなんなのさ、という感じだと思いますが、意外と Ruby を書いてると使ってるのです。


## Iterator
Ruby で配列の値をそれぞれ出力する時には each とかの Iterator を使うと思います

> というか Ruby 的には Enumerator と言った方が良いのかな

`Array.each` とか。

``` Ruby:iterator.rb
arr = [1, 1, 2, 3, 5]

arr.each do |item|
  puts item
end
```

これに渡している do から end までのものが `ブロック` なのです。
引数 `item` を取って、それを puts する、という `ブロック` を `Array.each` に渡している、と。
なので意外と自然に使ってたりします。 `lambda` だー、とか思う人は関数型な感じなのかもしれませんが私はさっぱりですす。

ちなみに、 `Iterator` って何ぞ、って人は Java だとこうです。

``` Java:IteratorSample.java
public class IteratorSample {
    public static void main(String args[]) {
        int[] arr = {1, 1, 2, 3, 5};
        for (int item : arr) {
            System.out.println(item);
        }
    }
}
```


## ブロックを取るメソッド
それで、実際ブロックを取るメソッドはどうやって書くのかというと、メソッドの引数の部分に & を付けると、そこにブロックが入ります。
こんな感じ

``` Ruby:proc_method.rb
def proc_arg_method item, &arg_proc
  arg_proc.call item
end

proc_arg_method 4 do |item|
  puts item
end
# => 4
```

メソッドにブロックと引数を渡してますねー。
処理を渡したい時に使います。

あと、`yield`と書けば、渡されたブロックを実行できるので

``` Ruby:yield_method.rb
def yield_method item
  yield item
end

yield_method 8 do |item|
  puts item
end
# => 8
```
と書いても良いです。

ちなみに、 `yield` とかのお手本は、ファイルの閉じ忘れをしないように

* ファイルを開く
* ここで処理
* ファイルを閉じる

ことらしいです。
 `File.open` とかに Block を渡すと勝手に閉じてくれるのはこんな感じだったりするのでしょうか。

``` Ruby:wrapper.rb
def wrapper_method file
  puts "open file"
  yield file
  puts "close file"
end

wrapper_method 16 do |file|
  puts "my file length is #{file}"
end
# =>
# open file
# my file length is 16
# close file
```

## each とかを書いてみよう
というわけで、Proc/Block で処理を渡すことができるようになったので、 `Array.each` を自分で実装してみましょう。

* 配列からを1つずつ値を取る
* 1つ取った値を、処理に投げる

ことでできそうですかねー?

> 楽勝な人は `Array.map` とか `Array.inject` とか `Array.all?` とか `Enumerator` の自前実装をしてみるのはどうでしょう
> `Array.inject` の実装気になる


あと、`lambda` っぽいよね、とか言っちゃったので慣れない `scheme` で each 書いてみました。
たぶんこんな感じ。

``` scheme:each.scm
(define (each arr block)
  (if (null? (cdr arr))
    (block (car arr))
    (begin (block (car arr))
           (each (cdr arr) block))))

(define arr '(1 1 2 3 5))
(define block (lambda (item) (begin (display item) (newline))))

(each arr block)

; =>
; 1
; 1
; 2
; 3
; 5
```

あと、処理を変数として移動できる、って点は `C` の `関数ポインタ` っぽいですよね。
ってな訳で `C` で書いた `each`。無理矢理感はある。

``` C:each.c
#include <stdio.h>
#define arr_length 5

void block(int);
void each(int[], void (*)(int));

int main(int argc, char const* argv[]) {
    int arr[arr_length] = {1, 1, 2, 3, 5};

    each(arr, block);
    
    return 0;
}

void block(int item) {
    printf("%d\n", item);
}

void each(int arr[], void (*block)(int)) {
    int i;
    for (i = 0; i < arr_length; i++) {
        block(arr[i]);
    }
}

/* =>
 * 1
 * 1
 * 2
 * 3
 * 5
 */
```

ってな感じで `Ruby` で `Array.each` 相当のものを書いてみましょう。

> `Open Class`はアレかもなので、普通のメソッドで。
> 完璧でなくても Block を扱うのがメインなのでそっちを気にしてもらえれば OK だと思います


テンプレはこんな感じになるでしょうか

``` Ruby:my_each.rb
def each arr
	# ...
end

each [1, 1, 2, 3, 5] do |item|
	puts item
end
```

## おわりに
ってな感じで Proc/Block でした。どうでしょう?

> 実際私は Proc/Block を使うようなコードは書いたこと無い気がする
> 関数型脳が足りないのだろーか
> というか関数型脳とはいったい

あと、この `markdown` は kobito でプレビューしながら書いたのですけれど、割と良い感じでした。
次回の Ryudai.rb #3 はの担当は……誰?

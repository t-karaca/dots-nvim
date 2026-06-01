; inherits yaml

((string_scalar) @injection.content
  (#set! injection.language "gotmpl"))

((double_quote_scalar) @injection.content
  (#set! injection.language "gotmpl"))

((single_quote_scalar) @injection.content
  (#set! injection.language "gotmpl"))

(block_node
  (block_scalar) @injection.content
  (#set! injection.language "gotmpl"))

(block_node
  (block_scalar
    (comment) @injection.language
    (#offset! @injection.language 0 2 0 0))
  @injection.content
  (#offset! @injection.content 0 1 0 0))

(if_statement
  consequence: (_) @context.end
) @context

; else is not part of any node itself, only what is executed as an alternative in the if_statement
; also only works if braces are on the same line like: `else {` or `} else {`
; creating a else_clause node in the parser would be the best solution
(
  (block) @context
  (#has-parent? @context if_statement)
)

(method_declaration
  name: (_) @context.start ; ignores annotations
  body: (_) @context.end
) @context

(constructor_declaration
  name: (_) @context.start ; ignores annotations
  body: (_) @context.end
) @context

(try_statement
  body: (_) @context.end
) @context

(try_with_resources_statement
  body: (_) @context.end
) @context

(catch_clause
  body: (_) @context.end
) @context

(finally_clause) @context

(for_statement
  body: (_) @context.end
) @context

(while_statement
  body: (_) @context.end
) @context

(enhanced_for_statement
  body: (_) @context.end
) @context

(class_declaration
  name: (_) @context.start ; ignores annotations
  body: (_) @context.end
) @context

(switch_expression) @context

(switch_block_statement_group) @context

(expression_statement) @context


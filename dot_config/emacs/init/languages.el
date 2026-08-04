;; TODO: add javascript typescript css html treesitter, auto start eglot
(use-package svelte-ts-mode
  :vc (:url "https://github.com/leafOfTree/svelte-ts-mode"))
						     
(add-to-list 'treesit-language-source-alist '(svelte "https://github.com/tree-sitter-grammars/tree-sitter-svelte"))
(add-to-list 'treesit-language-source-alist '(go "https://github.com/tree-sitter/tree-sitter-go" "v0.23.4"))
(add-to-list 'treesit-language-source-alist '(javascript "https://github.com/tree-sitter/tree-sitter-javascript" "v0.23.1"))
(add-to-list 'treesit-language-source-alist '(typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "typescript/src"))
(add-to-list 'treesit-language-source-alist '(tsx "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "tsx/src"))
(add-to-list 'treesit-language-source-alist '(css "https://github.com/tree-sitter/tree-sitter-css" "v0.23.2"))

(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-ts-mode))

;; EGLOT
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(svelte-ts-mode . ("svelteserver" "--stdio"))))
						     
(add-hook 'go-ts-mode-hook 'eglot-ensure)
(add-hook 'svelte-ts-mode-hook 'eglot-ensure)

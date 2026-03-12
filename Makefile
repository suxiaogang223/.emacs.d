EMACS ?= emacs
PACKAGE_USER_DIR ?= $(KANSO_PACKAGE_USER_DIR)
EMACS_BATCH = $(EMACS) --batch -Q --eval "(setq package-user-dir (expand-file-name (or (getenv \"KANSO_PACKAGE_USER_DIR\") package-user-dir)))"

.PHONY: bootstrap smoke test

bootstrap:
	$(EMACS_BATCH) -l init.el --eval "(bootstrap-packages)"

smoke:
	$(EMACS_BATCH) -l init.el

test:
	$(EMACS_BATCH) -l init.el \
		-l test/kanso-test-helper.el \
		-l test/kanso-core-test.el \
		-l test/kanso-lang-test.el \
		-f ert-run-tests-batch-and-exit

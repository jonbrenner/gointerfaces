GO_VERSION=1.2.2
NAME=gointerfaces
BUILD_DIR=build
BLOG_MD=blog.md
BLOG_SITE=../blog/txt/108.md
ARTICLE_MD=article.en.md
ARTICLE_XML=article.en.xml
ARTICLE_SITE=../sweetohm/pages/$(NAME).en.md

YELLOW=\033[93m
CLEAR=\033[0m

all: clean blog article publish

interfaces:
	@echo "$(YELLOW)Generate interfaces list$(CLEAR)"
	mkdir -p $(BUILD_DIR)
	go run $(NAME).go $(GO_VERSION) > $(BUILD_DIR)/interfaces.md

blog: interfaces
	@echo "$(YELLOW)Generate blog article$(CLEAR)"
	cp $(BLOG_MD) $(BUILD_DIR)
	sed -i -e "/INTERFACES/{r $(BUILD_DIR)/interfaces.md" -e "d}" $(BUILD_DIR)/$(BLOG_MD)
	sed -i -e "s/VERSION/$(GO_VERSION)/" $(BUILD_DIR)/$(BLOG_MD)

article: interfaces
	@echo "$(YELLOW)Generate site article$(CLEAR)"
	cp $(ARTICLE_MD) $(BUILD_DIR)
	sed -i -e "/INTERFACES/{r $(BUILD_DIR)/interfaces.md" -e "d}" $(BUILD_DIR)/$(ARTICLE_MD)
	sed -i -e "s/VERSION/$(GO_VERSION)/" $(BUILD_DIR)/$(ARTICLE_MD)
	md2xml -a $(BUILD_DIR)/$(ARTICLE_MD) > $(BUILD_DIR)/$(ARTICLE_XML)

publish:
	@echo "$(YELLOW)Publish blog and article on site$(CLEAR)"
	cp $(BUILD_DIR)/$(BLOG_MD) $(BLOG_SITE) 2> /dev/null || :
	cp $(BUILD_DIR)/$(ARTICLE_XML) $(ARTICLE_SITE) 2> /dev/null || :

clean:
	@echo "$(YELLOW)Clean generated files$(CLEAR)"
	rm -rf $(BUILD_DIR)

### Articles:
- https://nashuproar.org/wp-json/wp/v2/posts/13407
- content.rendered
- date
- link
- title
- author
- featured_media


### Media
- https://nashuproar.org/wp-json/wp/v2/media/15029
- date
- caption
- source_url


### Author
- https://nashuproar.org/wp-json/wp/v2/users/user_id
- name

### Categories
- json array
    - name
    - categoryID
- https://akshathjain.com/nashuproar/categories.json (category information)
    - count
    - name
- https://nashuproar.org/wp-json/wp/v2/posts?per_page=25?page=1&_embed&categories=category_number (category posts)
    - JSON Array
        - title.rendered
        - date
        - id 


### Search
- https://nashuproar.org/wp-json/v2/posts?search=query
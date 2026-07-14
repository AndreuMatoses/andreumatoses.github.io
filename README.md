---
layout: post
permalink: /readme/
---

# Andreu's personal academic website

This is the repository for my personal academic website. The website is built using Jekyll and hosted on GitHub Pages. The website uses [Bootstrap](https://getbootstrap.com/) and my own custom CSS for styling. Feel free to use this repository as a template for your own academic website, just keep the footer reference to this repository.

> [!NOTE]  
> Any file for projects, etc. can be either .md, or .html, just choose the most convenient and maintain the same frontmatter.

- [Andreu's personal academic website](#andreus-personal-academic-website)
  - [How to preview the website locally](#how-to-preview-the-website-locally)
  - [Basic Customization](#basic-customization)
    - [Changing Homepage Content](#changing-homepage-content)
  - [How to add new entries](#how-to-add-new-entries)
    - [Research Projects in the Homepage](#research-projects-in-the-homepage)
    - [Publications](#publications)
    - [Posts](#posts)
  - [Utilities (includes)](#utilities-includes)
    - [Gallery](#gallery)
    - [Figures](#figures)
    - [Linking local files and images in your content](#linking-local-files-and-images-in-your-content)
      - [The easy way](#the-easy-way)
      - [The manual way](#the-manual-way)


## How to preview the website locally

GitHub pages builds the website upon pushing to the `main` branch. However, if you want to preview the website locally before pushing, you can do so by following these steps:

1. Fork and then Clone the repository

2. Install build dependencies (you can also build it with ruby, but it is much easier with docker):
    - [Docker](https://docs.docker.com/get-docker/)
    - [Docker Compose](https://docs.docker.com/compose/install/)

3. Run the following command in the root directory of the repository:

    ```shell
    docker compose up
    ```

This will launch the website at `http://localhost:4000` with live-reload enabled. Hence, you should be able to make changes to any file and they should appear automatically on your local instance upon saving that file.

## Basic Customization
You can customize the website by changing the `_config.yml` file. This file contains the basic configuration for the website, such as the title, description, and social media links.

> [!IMPORTANT]
> Change the google_analytics key in the `_config.yml` file to your own!!!. Or just remove it if you don't want to use Google Analytics.

You can change your socials in the `_data/socials.yml` file. You can add or remove social media links as needed, with [Bootstrap icons](https://icons.getbootstrap.com/).

You can also change the navigation links in the `_data/navigation.yml` file. You can add or remove navigation links as needed. You can also nest subpages like this:

```yaml
- name: Group
  link: /group/
  subpages:
    - name: People
      link: /people/
    - name: Vacancies
      link: /vacancies/
```

### Changing Homepage Content
The homepage content is stored in the `index.md` file. You can change the content of the homepage by editing this file. Here you can also change the news by hand. 

## How to add new entries

### Research Projects in the Homepage
Projects are stored in the `_research` directory. To add a new project, create a new file in the `_research` directory. The file should have the front matter structure of the other examples. Each research entry creates its own website page, following the layout of the `_layouts/paper.html` file. I have kept this separate from publications items, as I sometimes add projects that are not a particular publication, or sometimes someone else is hosting the website.

### Publications
Publications are stored in the `_data/publications.json` file. Juts add yours (at the top for example, they then order by date) and commit. It has the following fields:

- `title`: The title of the publication. This should be a string.

- `authors`: An array of strings, where each string is the name of an author of the publication.

- `date`: The date of the publication in "YYYY-MM-DD" format. If you don't know the day or month, just put any (e.g 2023-01-01).

- `type`: The type of the publication (available: *"journal", "conference", "workshop", "thesis", "other"*.).

- `venue`: The venue where the publication was published (e.g., the name of a journal or conference). Do not put the year.

- `links`: A dictionary, where each object represents a link related to the publication. Each link object should have a name (e.g., "Website":, "PDF": ) and the associated URL.

- `note`: Any additional notes about the publication (e.g. "Nominated for best bets paper award"). This field is optional. is added after the date in the publication entry.

- `image`: (OPTIONAL) The path (or url) to an image file that represents the publication. This image is displayed on the publication's card on the website. **RECOMMENDED: The image should be square (same width and height)**. If you don't have an image, don't add this field.

- `abstract`: The abstract of the publication, as a long string.

Here's an example of what a publication object might look like:

```json
    {
        "title": "Physically Grounded Optimal Realizations of Symbolic Plans",
        "authors": [
            "Andreu Matoses Gimenez",
            "Nils Wilde",
            "Chris Pek",
            "Javier Alonso-Mora"
        ],
        "date": "2024-07-15",
        "type": "workshop",
        "venue": "Robotics: Science and Systems (RSS)",
        "links": [
            {
                "pdf": "/assets/files/publications/24_matoses_rss.pdf",
                "code": "http//github.com"
            }
        ],
        "image": "/assets/images/papers/realization_of_plans/dingo_isaac.png",
        "key_words": [
            "interact"
        ],
        "abstract": "Robot autonomy often ..."
    },
```

A basic search capability is provided in the publications page. You can remove it by setting `show_search: false` in the front matter of the `publications.html` file.

### Posts
Posts are stored in the `_posts` directory. To add a new post, create a new file in the `_posts` directory. The file should have the front matter structure of the other examples. Each post creates its own website page, following the layout of the `_layouts/post.html` file.

Posts, as well as research projects, can use mathjax for equations. Just put the mathjax code between `$$` symbols. For example:

$$ x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a} $$

You can also use the `highlight` tag to highlight code (useful for .html). For example:

{% highlight python %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

Or just use the triple backticks for code blocks (for .md files):

```python
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
```

You can also add a table of contents to your post by setting `show_toc: true` in the front matter. The table of contents will be generated based on the headings in your post.

## Utilities (includes)

### Gallery
You can include a gallery in any page by using the `gallery.html` include. The include takes two arguments: `images` and `n_columns`. The `images` argument is an array of image paths (or URLs) that you want to include in the gallery, defined in the front matter. The `n_columns` argument is the number of columns you want the gallery to have. Here's an example of how you might include a gallery in a page:

```markdown
{% include gallery.html images=page.gallery_experiments n_columns=2 caption="Robots in the vineyard in Rome" %}
```

### Figures

You can include figures (image) in your content by using the `figure.html` include. This makes it centered and responsive, of appropriate sizes. The include takes four arguments: `src`, `width`, `alt`, and `caption`. The `src` argument is the path to the image you want to include. The `width` argument is the width of the image in pixels. The `alt` argument is the alt text for the image. The `caption` argument is an optional caption for the image. Here's an example of how you might include a figure in a page:

```markdown
{% include figure.html src="/assets/images/pic.png" width="600" alt="picture" caption="Optional caption" %}
```

### Linking local files and images in your content

#### The easy way

You can use the following liquid tag to use the `include` fix_link.html, which will append whatever is necessary to the link. For example:

```html
<a href="{% include fix_link.html link='/assets/files/student_projects/Brochure_thesis_jam.pdf' %}">

<img class="img-fluid" src="{% include fix_link.html link='/assets/images/msc_projects/msc_project_template/hackathon-team.jpg' %}" alt="Image 1">

<img class="img-fluid" src="{% include fix_link.html link=image_variable.link %}" alt="Image 1">
```
#### The manual way

Github pages makes it a bit annoying to link to local (without the http://...) files and images. The easiest way is to put them in the `assets/...` directory. Then you can link to them using the `site.baseurl` variable to append to the path. For example, to link to the file `assets/files/publications/liu2022ral.pdf`, you can use the following markdown:

```markdown
[Link to the PDF]({{ '/assets/files/publications/23-wilde-ral.pdf' | relative_url}})
```
[Link to the PDF]({{ '/assets/files/publications/23-wilde-ral.pdf' | relative_url}})

Images are the same (put the html in the markdown file as is), just append the `relative_url` variable:

```html
<div class="image-div mb-3 d-flex justify-content-center">
    <img src="{{ '/assets/images/cover_pic_4x3.png' | relative_url}}" class="img-fluid" width="600" alt="lab">
</div>
```

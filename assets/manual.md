# Welcome to m-floww$
---
Thank you for choosing m-flow. This manual will guide you through the basics of using m-flow to create, format and enhance your documents. Let's dive in!

​

- ## Add Project and Start writing...

​

---
​

## Markdown Syntax Referencew$

1. ### Headings
   - Headings are created by placing one or more # symbols at the beginning of a line, followed by a space, and then the heading text.

     - # Heading 1
     - ## Heading 2
     - ### Heading 3
     - #### Heading 4
     - ##### Heading 5
     - ###### Heading 6

​

2. ### Paragraphs
   - This is a paragraph.

   - This is another paragraph.

​

3. ### Bold Text
   - Bold text is created by wrapping text with two asterisks (**) or two underscores (__).
     - **This text is bold**
   
     - __This text is also bold__

​

4. ### Italic Text
   - Italic text is created by wrapping text with one asterisk (*) or one underscore (_).

     - *This text is italic*

​

4. ### Strikethrough
   - Strikethrough text is created by wrapping text with two tildes (~~).
     - ~~This text is strikethrough~~

​

5. ### Blockquotes
   - Blockquotes are created by placing a > symbol in front of a line of text.
     - > This is a blockquote.

​

6. ### Lists
   - **Ordered Lists**: Created by numbering each item.
      - 1. First item
      - 2. Second item
      - 3. Third item
   - **Unordered Lists**: Created by using *, -, or + followed by a space.
     - First item
     - Second item
     - Third item

​

7. ### Code
   - Inline code is created by wrapping text with backticks (`). 
     - `inline code`
   - Code blocks are created by wrapping text with triple backticks (```).
     - ```This is inline code```

​

8. ### Links
   - Links are created by wrapping the link text in brackets '[]' and the URL in parentheses '()'.
     - [M-flow](https://www.m-flow.com)

​

9. ### Images
   - Images are created similarly to links, but with an exclamation mark (!) before the brackets.
     - ![Alt text](assets/icon.png)

​

10. ### Horizontal Rules
    - Horizontal rules are created by typing three or more hyphens (---), asterisks (***), or underscores (___) on a line by themselves.
    - for example: ---
      - ---

​

11. ### Tables
    - Tables are created using pipes (|) and hyphens (-).

| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Row 1    | Data 1   | Data 1 |
| Row 2    | Data 2   | Data 2 |

​

12. ### Escaping Characters
    - To display special characters like #,*,or _,You can escape them with a backslash (\).
   
        - \# This is not a heading.

    - [Note: for escaping `extended syntax`, You can use `\\`.][^1]

​

13. ### Footnotes
    - Footnotes are added by placing a caret (^) and an identifier inside brackets ([]) after the text, followed by the definition elsewhere.
    - Here's a footnote reference[^2].
    - [^2]: This is the footnote.

​

14. ### Task Lists
    - Task lists are created using - [ ] for unchecked items and - [x] for checked item.
       - [x] Completed task
       - [ ] Incomplete task

​

15. ### Subscript
    - Subscript text is created by wrapping the text with tildes (~).
      - [^1]: This is a \\~subscript~ text will render as: This is a ~subscript~.

​

16. ### Superscript
    - Superscript text is created by wrapping the text with (^).
      - This is a \\^superscript^ text will render as: This is a ^superscript^.

​

---

​

## M-Flow Exclusive Syntaxw$

 1. ### M$
   - In our app, if you want to add extra spaces after Markdown syntax without breaking the formatting, just start the line with `m$`. 
   - This special syntax lets you move things around or add spaces, and your Markdown will still render correctly, without being treated as plain text.
     -            **bold** 
     - m$      **bold**

​

2. ### W$
  - To center any text or content, you can prepend the line with `w$`, which will automatically center the text. 
  -  Alternatively, you can use the `center alignment icon` located above the left form.

 **centered text**w$

​

3. ### R$
  - To align any text or content to the right, you can prepend the line with `r$ `, which will automatically align the text to the right. 
  - Alternatively, you can use the right alignment icon located above the left form.

 **Right** align textr$

​

4. ### Underline
    - Underline under text is created by wrapping the text with (--).
    - This is a \\--underline-- text will render as: This is --underline--.

​

5. ### Upload
 - With our Md editor, you can easily upload images to enhance your documents. 
 - Adding images to your document is very easy. Just click the `image-icon` above the left panel, select the image you want to add, and it will be instantly integrated with your document.

​

---

​

## Math-Jaxw$

1. ### Usage
  - Our Markdown editor supports the use of mathematical expressions to enhance your documents.
  - To utilize MathJax, enclose your mathematical syntax within $$. This will render the expressions in a polished and visually appealing format.
  - For convenience, you can also click on the $$\sum$$ icon to quickly access MathJax features.

​

2. ### Mathjax syntax examples:

- $$a^2 + b^2 = c^2$$

​

- $$\frac{a}{b}$$

​

- $$ x_i^2 $$

​

- $$a^2 \quad + \quad b^2 $$  `used to insert a space in mathematical expressions.`

​

- $$ \begin{matrix} a & b \\ c & d \end{matrix} $$ $$\quad $$ $$ \begin{pmatrix} a & b \\ c & d \end{pmatrix} $$  $$\quad $$ $$ \begin{vmatrix} a & b \\ c & d \end{vmatrix} $$
$$\quad $$ $$ \begin{bmatrix} a & b \\ c & d \end{bmatrix} $$

​

- $$ \sqrt{x^2 + y^2} $$

​

- $$ \sum_{i=1}^{n} i $$

​

- $$ \int_{0}^{1} x^2 dx $$

​

- $$ \alpha, \quad \beta, \quad \gamma, \quad  \Delta, \quad  \pi $$

​

- $$ a \pm b, \quad a \times b, \quad a \div b $$

​

- $$ x = \frac{a + b}{c} \quad \text{where} \quad a, b, \text{ and } c \text{ are constants}$$

​

---
## Thank you!w$





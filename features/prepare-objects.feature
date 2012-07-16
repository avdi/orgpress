@slow
Feature: Prepare objects

  Scenario: Split long lines
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/extract/neutral/LISTINGS" with:
    """
    the-foo-book-001.listing

    """
    And a file named "build/extract/neutral/the-foo-book-001.listing" with:
    """
    filename: the-foo-book.monolith
    number: 1
    name: the-foo-book-001
    
    #+BEGIN_SRC ruby
      puts "this is line 1"
      puts "this is line 2"
      puts "this is line 3"
      puts "this is line 4"
      puts "this is line 5"
      puts "this is line 6"
      puts "this is line 7"
      puts "this is line 8"
      puts "this is line 9"
      puts "this is line 10"
      puts "this is line 11"
      puts "this is line 12"
      puts "this is line 13"
      puts "this is line 14"
      puts "this is line 15"
      puts "this is line 16"
      puts "this is line 17"
      puts "this is line 18"
      puts "this is line 19"
      puts "this is line 20"
      puts "this is line 21"
      puts "this is line 22"
      puts "this is line 23"
      puts "this is line 24"
      puts "this is line 25"
      puts "this is line 26"
      puts "this is line 27"
      puts "this is line 28"
      puts "this is line 29"
      puts "this is line 30"
      puts "this is line 31"
      puts "this is line 32"
      puts "this is line 33"
      puts "this is line 34"
      puts "this is line 35"
      puts "this is line 36"
      puts "this is line 37"
      puts "this is line 38"
      puts "this is line 39"
      puts "this is line 40"
      puts "this is line 41"
      puts "this is line 42"
      puts "this is line 43"
    #+END_SRC

    """
    And a file named "build/extract/neutral/the-foo-book-002.listing" with:
    """
    filename: the-foo-book.monolith
    number: 2
    name: the-foo-book-002
    caption: goodbye in ruby
    
    #+BEGIN_SRC ruby
    def bar
      puts "goodbye, world"
    end
    #+END_SRC

    """
    When I run `orgpress prepare-objects`
    Then the exit status should be 0
    And the file "build/prepare-objects/pdf/the-foo-book-001.mlisting" should contain exactly:
    """
    #+BEGIN_SRC ruby
    puts "this is line 1"
    puts "this is line 2"
    puts "this is line 3"
    puts "this is line 4"
    puts "this is line 5"
    puts "this is line 6"
    puts "this is line 7"
    puts "this is line 8"
    puts "this is line 9"
    puts "this is line 10"
    puts "this is line 11"
    puts "this is line 12"
    puts "this is line 13"
    puts "this is line 14"
    puts "this is line 15"
    puts "this is line 16"
    puts "this is line 17"
    puts "this is line 18"
    puts "this is line 19"
    puts "this is line 20"
    puts "this is line 21"
    puts "this is line 22"
    puts "this is line 23"
    puts "this is line 24"
    puts "this is line 25"
    puts "this is line 26"
    puts "this is line 27"
    puts "this is line 28"
    puts "this is line 29"
    puts "this is line 30"
    puts "this is line 31"
    puts "this is line 32"
    puts "this is line 33"
    puts "this is line 34"
    puts "this is line 35"
    puts "this is line 36"
    puts "this is line 37"
    puts "this is line 38"
    puts "this is line 39"
    puts "this is line 40"
    puts "this is line 41"
    puts "this is line 42"
    #+END_SRC
    #+BEGIN_SRC ruby
    puts "this is line 43"
    #+END_SRC

    """
    And the file "build/prepare-objects/neutral/the-foo-book-001.mlisting" should contain exactly:
    """
    #+BEGIN_SRC ruby
    puts "this is line 1"
    puts "this is line 2"
    puts "this is line 3"
    puts "this is line 4"
    puts "this is line 5"
    puts "this is line 6"
    puts "this is line 7"
    puts "this is line 8"
    puts "this is line 9"
    puts "this is line 10"
    puts "this is line 11"
    puts "this is line 12"
    puts "this is line 13"
    puts "this is line 14"
    puts "this is line 15"
    puts "this is line 16"
    puts "this is line 17"
    puts "this is line 18"
    puts "this is line 19"
    puts "this is line 20"
    puts "this is line 21"
    puts "this is line 22"
    puts "this is line 23"
    puts "this is line 24"
    puts "this is line 25"
    puts "this is line 26"
    puts "this is line 27"
    puts "this is line 28"
    puts "this is line 29"
    puts "this is line 30"
    puts "this is line 31"
    puts "this is line 32"
    puts "this is line 33"
    puts "this is line 34"
    puts "this is line 35"
    puts "this is line 36"
    puts "this is line 37"
    puts "this is line 38"
    puts "this is line 39"
    puts "this is line 40"
    puts "this is line 41"
    puts "this is line 42"
    puts "this is line 43"
    #+END_SRC

    """

  Scenario: Fancy listings
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/extract/neutral/LISTINGS" with:
    """
    the-foo-book-001.listing

    """
    And a file named "build/extract/neutral/the-foo-book-001.listing" with:
    """
    filename: the-foo-book.monolith
    number: 1
    name: the-foo-book-001
    caption: goodbye in ruby
    
    #+BEGIN_SRC ruby
      def bar
        puts "goodbye, world"
      end
    #+END_SRC

    """
    When I run `orgpress prepare-objects`
    Then the exit status should be 0
    And the file "build/prepare-objects/neutral/the-foo-book-001.mlisting" should contain exactly:
    """
    #+HTML: <div class="listing source">
    #+LaTeX: \begin{listing}[H]
    #+LaTeX: \caption{goodbye in ruby}
    #+BEGIN_SRC ruby
    def bar
      puts "goodbye, world"
    end
    #+END_SRC
    #+LaTeX: \end{listing}
    #+HTML: <div class="caption">goodbye in ruby</div>
    #+HTML: </div>

    """
    And the file "build/prepare-objects/pdf/the-foo-book-001.mlisting" should contain exactly:
    """
    #+HTML: <div class="listing source">
    #+LaTeX: \begin{listing}[H]
    #+LaTeX: \caption{goodbye in ruby}
    #+BEGIN_SRC ruby
    def bar
      puts "goodbye, world"
    end
    #+END_SRC
    #+LaTeX: \end{listing}
    #+HTML: <div class="caption">goodbye in ruby</div>
    #+HTML: </div>

    """

  Scenario: Listing with identifier
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/extract/neutral/LISTINGS" with:
    """
    the-foo-book-001.listing

    """
    And a file named "build/extract/neutral/the-foo-book-001.listing" with:
    """
    filename: the-foo-book.monolith
    number: 1
    name: the-foo-book-001
    identifier: goodbye-world
    caption: goodbye in ruby
    
    #+BEGIN_SRC ruby
      def bar
        puts "goodbye, world"
      end
    #+END_SRC

    """
    When I run `orgpress prepare-objects`
    Then the exit status should be 0
    And the file "build/prepare-objects/neutral/the-foo-book-001.mlisting" should contain exactly:
    """
    #+HTML: <div class="listing source">
    #+LaTeX: \begin{listing}[H]
    #+LaTeX: \caption{goodbye in ruby}
    #+NAME: goodbye-ruby
    #+BEGIN_SRC ruby
    def bar
      puts "goodbye, world"
    end
    #+END_SRC
    #+LaTeX: \end{listing}
    #+HTML: <div class="caption">goodbye in ruby</div>
    #+HTML: </div>

    """

  Scenario: Pygmentized HTML listings
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/extract/neutral/LISTINGS" with:
    """
    the-foo-book-001.listing

    """
    And a file named "build/extract/neutral/the-foo-book-001.listing" with:
    """
    filename: the-foo-book.monolith
    number: 1
    name: the-foo-book-001
    identifier: goodbye-world
    caption: goodbye in ruby
    
    #+BEGIN_SRC ruby
      def bar
        puts "goodbye, world"
      end
    #+END_SRC

    """
    When I run `orgpress prepare-objects`
    Then the exit status should be 0
    And the file "build/prepare-objects/html/the-foo-book-001.mlisting" should contain exactly:
    """
    #+BEGIN_HTML
    <div class="listing source">
    <div class="highlight"><pre><span class="k">def</span> <span class="nf">bar</span>
      <span class="nb">puts</span> <span class="s2">&quot;goodbye, world&quot;</span>
    <span class="k">end</span>
    </pre></div>
    <div class="caption">goodbye in ruby</div>
    </div>
    #+END_HTML

    """

  Scenario: Pygmentized HTML output listings
    Given a file named "book.yml" with:
    """
    book_name: the-foo-book
    """
    And a file named "build/extract/neutral/LISTINGS" with:
    """
    the-foo-book-001.listing

    """
    And a file named "build/extract/neutral/the-foo-book-001.listing" with:
    """
    filename: the-foo-book.monolith
    number: 1
    name: the-foo-book-001
    role: output
    
    #+BEGIN_EXAMPLE
    output line 1
    output line 2
    #+END_EXAMPLE

    """
    When I run `orgpress prepare-objects`
    Then the exit status should be 0
    And the file "build/prepare-objects/html/the-foo-book-001.mlisting" should contain exactly:
    """
    #+BEGIN_HTML
    <div class="listing output">
    <div class="highlight"><pre>output line 1
    output line 2
    </pre></div>
    </div>
    #+END_HTML

    """

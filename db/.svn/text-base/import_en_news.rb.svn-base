#!/usr/bin/env ruby

RAILS_ENV = 'production'

# load the Rails environment (for ActiveRecord)
require File.join(File.dirname(__FILE__), "..", "config", "environment")

def user( name, login, password, parent )
  user = User.find_by_name(name)
  return user unless user.nil?
  
  old = UserActionObserver.current_user
  UserActionObserver.current_user = parent
  user = User.create!(
    :name                  => name,
    :login                 => login,
    :password              => password,
    :password_confirmation => password,
    :updated_by            => parent
  )
  UserActionObserver.current_user = old
  user
end

james   = user( "James Edward Gray II", "JEG2", "Blitz",
                User.find_by_name("Administrator") )
unknown = user("Unknown Author", "unknown", "unknown", james)
news    = Page.find_by_slug("news")

news.children.each { |page| page.destroy }

YAML.load(DATA).each do |article|
  UserActionObserver.current_user = article[:author].empty? ? unknown : user(*([article[:author]] * 2 + ["12345", james]))
  page = Page.create!(
    :title        => article[:title],
    :breadcrumb   => article[:title],
    :slug         => article[:title].downcase.tr(" \t\n", "---").delete("^-a-z0-9"),
    :status_id    => 100,
    :parent       => news,
    :updated_by   => james,
    :published_at => Date.civil(*article[:date].scan(/\A\d{4}|\d{2}/).map { |i| i.to_i })
  )
  PagePart.create!(
    :name      => "body",
    :content   => article[:content],
    :page      => page,
    :filter_id => "Textile"
  )
end

__END__
--- 
- :content: |
    <p> <a href="ftp://ftp.ruby-lang.org/pub/ruby/stable-snapshot.tar.gz">Stable snapshot</a> is available.
    This is tar'ed and gzip'ed file of the latest stable CVS. It should be better than the last release.</p>

  :date: "20010118"
  :title: Stable snapshot is available
  :author: Matz
- :content: |
    <p> O'Reilly finally decided to publish translation of Ruby Pocket Reference.
    It will be <a href="http://www.ora.com/catalog/ruby">full-sized book titled "Ruby in a Nutshell"</a>. </p>

  :date: "20010419"
  :title: Ruby Pocket Reference
  :author: Matz
- :content: |
    <p> <a href="http://www.rubygarden.org/">Ruby Garden</a> - News Portal for Ruby.</p>

  :date: "20010620"
  :title: Ruby Garden
  :author: Matz
- :content: |
    <p> <a href="http://www.io.com/~jimm/downloads/rubytalk/">Ruby introduction presentation at New York City CTO club</a> by Jim Menard on July 10, 2001.</p>

  :date: "20010713"
  :title: Ruby introduction presentation
  :author: Matz
- :content: |
    <p> Matz desided to remove the page.<p>
    <pre>
    "I removed the link to the language comparison page,
    because there're too many people to take it too serious.
    It was supposed to be funny."
    </pre>

  :date: "20010710"
  :title: Removed language comparison page
  :author: NaHi
- :content: |
    We are waiting your impression about Ruby.  <a href="mailto:webmaster@ruby-lang.org">Mail us</a>.
    <dl>
    <dt>From: Yukihiro Matsumoto &lt;matz at ruby-lang.org&gt;</dt>
    <dd>Programming in Ruby is very fun.  Debugging Ruby itself is not fun sometimes ;-)</dd>
    <dt>From: Clemens Hintze &lt;c.hintze at gmx.net&gt;</dt>
    <dd>Like any programmer I know many programming languages. It has took me three weeks to decide to learn Perl, one week for the decision to learn Python and ONE day to decide to learn Ruby!!!</dd>
    <dt>From: Dave Thomas &lt;dave at pragmaticprogrammer.com&gt;</dt>
    <dd>You know, the more I use Ruby, the more I appreciate what a great job you did with it. It truly is a great language, and it deserves to be up there with the Perls and Pythons - I'm convinced now it's more general than both of them.</dd>
    <dt>From Andrew Hunt &lt;andy at pragmaticprogrammer.com&gt;</dt>
    <dd>Ruby is terrific at honoring the "Princple of Least Surprise". I can't think of another language where I can type in code for such a long time and have it run first try!</dd>
    <dt>From dotw at dotw.cjb.net</dt>
    <dd>I must say, I was surprised at how nice Ruby is. :-) I've been using Python for some time, and I didn't really think Ruby could improve on it. To be truthful, I've learned how to do more in Ruby in the past day than I learned in a month of using and reading about Python. Ruby is incredibly simple and straightforward; it's almost shocking how much of the language is actually LOGICAL. Great work! :-)</dd>
    <dt>From Guy N. Hurst &lt;gnhurst at hurstlinks.com&gt;</dt>
    <dd>I would call it charming.  Imagine in that description the person being a programmer finding something pleasing in performance.</dd>
    <dd>Also, Ruby has a noble association.  Python is either a snake, or an irreverent comedy show.  Perl is based on a grain of sand, formed over time in a clam. Nicer.  But Ruby is both gem and harmonious warbler (ruby-crowned kinglet).  It reigns charmingly over the rest, and is pleasing to all who come across it.</dd>
    <dd>As matz once said, 
    <pre>
    The purpose of Ruby is to maximize programming pleasure.
    Programming in Ruby is extremely fun, for me at least.
    </pre>
    Perhaps musical, lively, and noble can be used...<br>Ruby is a noble programming language. Fit for a king. Ruby rules. Perl is nice for the gates to get there, and no comment about python.</dd>
    <dt>From Mathieu Bouchard &lt;matju at CAM.ORG&gt;</dt>
    <dd><ul>
    <li>Imperative
    In Ruby, programs are made of statements accessing and modifying the state of variables, executed in a well-defined order. Most popular programming languages are like that.</li>
    <li>Object-based
    In Ruby, most operations are made in the context of an object. All values, containers, procedures, classes are objects. Anything referenced by a variable is an object. Thus Ruby is closer to SmallTalk than to Java or Python.</li>
    <li>Dynamic:
    It has runtime procedure call dispatching (inheritance polymorphism), runtime definition of new procedures, classes and modules, and runtime parsing.  Variables may hold objects of any class (Weak typing). It offers mark and sweep garbage collection so that there is no need to free memory explicitly (even with reference loops).</li>
    </ul></dd>
    <dt>From Conrad Schneiker &lt;schneik at us.ibm.com&gt;</dt>
    <dd>OK, take the bull by the horns: Ruby the next-generation POST-SCRIPTING language (for those who have outgrown so-called scripting languages).</dd>
    <dd>Alternatively, enchant the bull: Ruby is an ultra-class programming language--i.e. ultra-flexible, ultra-OO, ultra-dynamic, ultra-readable, ultra-maintainable.</dd>
    <dd>Or stand on the shoulder's of giants: Ruby has the flexibility of Perl, the readability of Python, and the dynamic OO power of Smalltalk--all in one convenient package.</dd>
    <dt>From Aleksi Niemela &lt;aleksi.niemela at cinnober.com&gt;</dt>
    <dd>You want code fast, test your ideas, pay little attention to unnecessary details, be able to weld existing technologies, and you end up using scripting languages. You want create bigger, clear, maintainable programs and you count Perl and TCL out. You want be flexible with your language and habits, want to learn one language for small and big tasks and you couldn't use Python. It seemed there's no one language to satisfy most needs. But there is. Ruby is balanced mixture of functionality and imperativeness, real OO programming and tricks for quick hacks..um..solutions, tested and tried technologies.</dd>
    <dd>To me, Ruby is a ruddy language! (In a sense it has a healthy reddish color.)</dd>
    <dt>From David Douthitt &lt;DDouthitt at cuna.com&gt;</dt>
    <dd>I can say why I learned it (which has been quite recently). In my case, any benefit from Ruby had to overcome what benefits there were from using Perl and Korn Shell (both of which are quite powerful!).</dd>
    <dd><ul>
    <li>Wanted to learn Object-Orientated Programming (OOP). I've tried to teach myself Smalltalk (anyone know Pocket Smalltalk? :-) but without a guru to bother with endless and inane questions it gets to be tough and can make one not continue, even if only by apathy and laziness.</li>
    <li>Code easier to maintain.  OOP can be much easier to maintain, and includes many programming ideas which help considerably.</li>
    <li>Code easier to prove correctness.  OOP helps in this area too, helping to make things not only work, but provably correct (or closer to it).</li>
    <li>Extensible.  Another OOP advantage - if you don't like how a feature works, you can rewrite it.</li>
    </ul></dd>
    <dd>Then there are the reasons I continued to learn it :-)</dd>
    <dd><ul>
    <li>Large base of users and gurus, with quick responses not only from major book authors, but also from recognized Japanese software wizards :-)  I'm starting to realize the unrealized importance of a support network, of being able to ask dumb questions and get answers (ofttimes with gentle reminders to read the FAQ :-)</li>
    <li>Power. The capabilities of Ruby are incredible - networking? Web servers? Amazing.</li>
    </ul></dd>
    <dt>From Hugh Sasse &lt;hgs at dmu.ac.uk&gt;</dt>
    <dd>Where I heard about it?  One of the language lists on the web, or when browsing for Perl information I found references to Ruby as a "successor" to Perl.  This was some time back, a vague memory suggests that this was when ruby was at 0.8 or thereabouts.  I did not pursue it then as I thought it would be too likely to change.</dd>
    <dd>Why I moved to it?  I tried to develop some sockets code. I wanted a more flexible system for development and test than C++ and knew that Perl had sockets in it.  However, there are now two sockets libraries in Perl, and I could not find clear documentation on how to use UDP with Perl and one library only.  Also, although I had learned Python and have written some useful things in it, I ended up looking for the newer ruby stuff first, and found it had a sockets library that was usable.</dd>
    <dd>I found the OO code in Ruby clearer to read than Perl's.  Also, earlier in my code development I found that fact that you could not just extend the Dictionary class in Python, but had to use "contains" rather than "inherits" to go further, rather irritating.</dd>
    <dt>From Dayalan R. Pillay &lt;dayalan at free.net.nz&gt;</dt>
    <dd>Ruby is so elegant and fast, I plan to use only it and Java.  One more day with Ruby and I may not need Java.</dd>
    <dt>From John Small &lt;jsmall at laser.net&gt;</dt>
    <dd>Knowing Perl, Python and Smalltalk I learned Ruby in one day. It is more fun to use than Smalltalk yet has the hack power of Perl but without obfuscating your intent.</dd>
    <dt>From Ot Ratsaphong &lt;progress at asiaonline.net.au&gt;</dt>
    <dd>I am currently learning PHP and was planning to learn Python next as a more generic OO programming language, until I discovered Ruby yesterday (27.11.2000). Now, I'm pretty sure I'm going to have to Python a miss. What a pity. I was looking forward to learning Python. It seemed to have everything I wanted. But Ruby is a purer OO language and has all the things I want from Python Plus more. Got to go with the way of the future.</dd>
    <dt>From Bill Pyritz &lt;pyritz at lucent.com&gt;</dt>
    <dd>I have a C++ background. When faced with a problem to solve, I get a mental impression of the solution. In C++, I find that I need to go through several layers of translation before I can express it in the language. With Ruby, the idea seems to naturally express itself in the language. This is the power of Ruby, I believe.</dd>
    <dt>From Eric Benoit &lt;eric at ecks.org&gt;</dt>
    <dd>I've been looking for a good language to figure this OO stuff out with. I was originally considering Java, then Smalltalk, then Python, and then even C++. Ruby, however, seems to be the optimal language in which to learn what OO is all about, without any cruftiness, implementation issues or run-time bothers. Thanks guys.</dd>
    <dt>From Matthias Lampert &lt;ml at sph.de&gt;</dt>
    <dd>After 4 weeks with Ruby I find myself `bewitched, entranced and fascinated' [The Wind In The Willows].  I think it's time for me to study the source to find out where Matz has implemented Ruby's ability to read my mind.</dd>
    <dd>I believe Ruby can do a very great job to give a lot of students an idea about the principles and techniques of OOP before they are swallowed by all the quicksand C++ and Java have on their paths.  As far as I'm concerned, I will encourage them greatly to take this step first.</dd>
    <dt>From Christoph Jungen &lt;Christoph.Jungen at lt.admin.ch&gt;</dt>
    <dd>I used to work with Smalltalk for several years and I loved this language (pure OO, everything is an object, etc.) and to work with it. Then, unfortunately, I had to "go back" to develop software with C/C++... and I think, I became obviously less productive than I was before. But a few weeks ago, I first heard of Ruby, immediately bought "the book" (Thomas/Hunt), downloaded "the stuff" and started using it at my job, doing all the tasks writing beatuful code again like in the old days... and I immediately felt in love with this new language! The language is really great - the I only thing I'm still missing at the moment is the nice integrated working environement I had using Smalltalk-80, but that's only a detail...</dd>
    <dt>From John Johnson &lt;john at johnjohnsonsoftware.com&gt;</dt>
    <dd>Ruby is a Hoopless language. All other languages I've learned have a certain point that you come to which I call "The Hoops." You don't realize they are there when you begin learning the language. They present themselves when you start actually doing work in the language. That is when you meet them. They are the hoops you have to jump through to get your work done. With it's built-in iterators, introspection, method_missing, etc. Ruby is a Hoopless language.</dd>
    <dd>Another testament to Ruby's difference are the adjectives used to describe it. I've never heard "beautiful, elegant, charming, etc." used to describe any programming language. Ruby has a very bright future. Thanks Matz!</dd>
    <dt>From Bill Pyritz &lt;pyritz at lucent.com&gt;</dt>
    <dd>Just wanted to let you know that Ruby is being used within Lucent on a 3G wireless telephony product. I have written a parser and code generator amounting to ~6K ruby code that generates ~150K C++ source code.</dd>
    <dd>So, Ruby is being used within the telephony world on a critical application. Next time you use your cellular phone, you can imagine the Ruby generated code playing a critical role in the connection!</dd>
    <dt>From Rick Bates &lt;rick10811 at hotmail.com&gt;</dt>
    <dd>Just wanted to say thanks for the great language.  I've never ran across something that I started to like so quickly.  I think ruby is the ONLY language I've used that I can 'figure out', before actually learning.  Rather, if I don't know how to do something, I can usually guess how, and it works...almost as if ruby is a mind reading OO language.  I can't wait to see it become more popular.  One of my favorite things about ruby has to be that it is OO when you need it, but you can 'ignore' that if you don't.  In other words, I can program with a style very similar to perl and other scripting languages and never really have to mess with OO concepts if I dont feel like it.  This all makes ruby, in my opinion, one of the easiest and most powerfull scripting languages around, and the best.</dd>
    <dt>From Craig M. Moran &lt;MoranCM at navair.navy.mil&gt;</dt>
    <dd>The power of C++.  The ease of scripting with Perl.  More fun and easier than both!  It is so very nice to watch a masterpiece at work.  I come to work and launch my Ruby script then kick back and watch in awe as it does 45 minutes worth of work for me unattended!!!    Mind you, the work it does used to be accomplished in no less than 4 weeks by hand.  This is powerful stuff, my friends.</dd>
    <dt>From flx frnzs &lt;matschke.felix gmx.de&gt;</dt>
    <dd>I am a structural engineer and use Ruby ... every single day. Mainly for small scripts that to that nasty work that nobody would do for me and that could have been written in many other languages. But there is more: I don't know wether there are many engineers out there using object oriented programming features in production environments, but there should. My programs now do a lot more than what could have been done all these other ways. Stop fiddling with huge Excel-files and VBA. Stop compiling fortran77. Start programming in a language that optimizes programming time, not execution time.</dd>
    </dl>

  :date: "20020110"
  :title: Testimonial
  :author: ""
- :content: |
    Ruby is the interpreted scripting language for quick and easy object-oriented programming. It has many features to process text files and to do system management tasks (as in Perl). It is simple, straight-forward, extensible, and portable.
    Oh, I need to mention, it's totally free, which means not only free of charge, but also freedom to use, copy, modify, and distribute it.
    Features of Ruby
    <ul><li></li><li>Ruby has simple syntax, partially inspired by Eiffel and Ada.</li><li>Ruby has exception handling features, like Java or Python, to make it easy to handle errors.</li><li>Ruby's operators are syntax sugar for the methods. You can redefine them easily.</li><li>Ruby is a complete, full, pure object oriented language: OOL. This means all data in Ruby is an object, in the sense of Smalltalk: no exceptions. Example: In Ruby, the number 1 is an instance of class Fixnum.</li><li>Ruby's OO is carefully designed to be both complete and open for improvements. Example: Ruby has the ability to add methods to a class, or even to an instance during runtime. So, if needed, an instance of one class *can* behave differently from other instances of the same class.</li><li>Ruby features single inheritance only, *on purpose*. But Ruby knows the concept of modules (called Categories in Objective-C). Modules are collections of methods. Every class can import a module and so gets all its methods for free. Some of us think that this is a much clearer way than multiple inheritance, which is complex, and not used very often compared with single inheritance (don't count C++ here, as it has often no other choice due to strong type checking!).</li><li>Ruby features true closures. Not just unnamed function, but with present variable bindings.</li><li>Ruby features blocks in its syntax (code surrounded by '{' ... '}' or 'do' ... 'end'). These blocks can be passed to methods, or converted into closures.</li><li>Ruby features a true mark-and-sweep garbage collector. It works with all Ruby objects. You don't have to care about maintaining reference counts in extension libraries. This is better for your health. ;-)</li><li>Writing C extensions in Ruby is easier than in Perl or Python, due partly to the garbage collector, and partly to the fine extension API. SWIG interface is also available.</li><li>Integers in Ruby can (and should) be used without counting their internal representation. There *are* small integers (instances of class Fixnum) and large integers (Bignum), but you need not worry over which one is used currently. If a value is small enough, an integer is a Fixnum, otherwise it is a Bignum. Conversion occurs automatically.</li><li>Ruby needs no variable declarations. It uses simple naming conventions to denote the scope of variables. Examples: simple 'var' = local variable, '@var' = instance variable, '$var' = global variable. So it is also not necessary to use a tiresome 'self.' prepended to every instance member.</li><li>Ruby can load extension libraries dynamically if an OS allows.</li><li>Ruby features OS independent threading. Thus, for all platforms on which Ruby runs, you also have multithreading, regardless of if the OS supports it or not, even on MS-DOS! ;-)</li><li>Ruby is highly portable: it is developed mostly on Linux, but works on many types of UNIX, DOS, Windows 95/98/Me/NT/2000/XP, MacOS, BeOS, OS/2, etc.</li></ul>
    The Creator of Ruby
    Yukihiro Matsumoto, a.k.a Matz <a href="mailto:matz@netlab.jp">matz@netlab.jp</a>

  :date: "20020101"
  :title: What's Ruby
  :author: ""
- :content: |
    How to get Ruby.
    <ul><li></li><li>The stable release <a href="ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.4.tar.gz">ruby-1.8.4</a>.</li><li>The CVS branch for the development version is available. See <%=my "20020106", "CVS Repository Guide"%%> </li></ul>

  :date: "20020102"
  :title: Download Ruby
  :author: ""
- :content: |
    <!-- updated, and broken links removed or commented,
    David Black, January 20, 2005
    -->
    Sites
    <ul>
    <li><a href='http://www.ruby-doc.org'>ruby-doc.org</a>, lots of information and lots of links to more</li>
    </ul>
    Reference Manuals
    <ul>
    <li><a href='http://www.ruby-doc.org/docs/ruby-doc-bundle/'>Ruby Documentation Bundle</a>, from <a href='http://www.ruby-doc.org'>ruby-doc.org</a></li>
    <li><a href="http://www.rubycentral.com/ref/index.html">Ruby 1.6 Built-in library Reference</a></li>
    <!-- This link isn't working
    <li><a href="man-1.4/index.html">Ruby 1.4 Reference Manual</a>: Ruby 1.6 & 1.8 reference manual is not yet prepared...</li> -->
    <li><a href="ftp://ftp.ruby-lang.org/pub/ruby/doc/ruby-man-1.4.6.tar.gz">Tar'ed and Gzip'ed reference manual</a> (Ruby 1.4)</li>
    <ul>
    <!-- This link isn't working
    <li><a href="/en/pdf-doc/ruby-man.pdf">Ruby 1.4 Reference Manual(PDF)</a></li> -->
    </ul>
    </ul>
    Learning Ruby Online
    <ul><li></li><li><a href="http://www.rubycentral.com/book">Programming Ruby</a> (first edition) -- free online book</li><li><a href="http://www.rubygarden.org/faq">Ruby FAQ</a></li><li><a href="http://www.math.umd.edu/%7Edcarrera/ruby/0.3/">Introduction to Ruby</a> by Daniel Carrera</li><li><a href="http://www.poignantguide.net/ruby/">why's (poignant) guide to Ruby</a> -- unique and captivating Ruby resource</li><li><a href="http://pine.fm/LearnToProgram/">Learning to Program</a>: A tutorial for the non-programmer by Chris Pine</li><li><a href="http://www.glue.umd.edu/%7Ebilltj/ruby.html">Things That Newcomers to Ruby Should Know</a> by William Djaja Tjokroaminata</li><li><a href="http://www.rubyist.net/%7Eslagell/index.html">Ruby User's Guide (introductory tutorial)</a><!-- These links are broken </li><li><ul><li><a href="/en/pdf-doc/rubyguide_A4.pdf">Ruby User Guide(PDF, A4, 06-Apr-01)</a></li><li><a href="/en/pdf-doc/rubyguide_letter.pdf">Ruby User Guide(PDF, US letter, 06-Apr-01)</a></li></ul></li><li>--></li><li><a href="http://www.rubygarden.org/ruby?RubyBookList">RubyBookList#{ext}</a></li></ul></a></li>
    </ul>

  :date: "20020103"
  :title: Ruby Documents
  :author: ""
- :content: |
    There are several English speaking mailing lists (MLs) to talk about Ruby language itself.
    <ul>
    <li>One is <dfn>ruby-talk</dfn>, which deals with <em>general topics</em> about Ruby.</li>
    <li>Another is <dfn>ruby-core</dfn>, which deals with <em>core / implementation topics</em> about Ruby, often used to run patches for review.</li>
    <li>There is also <dfn>ruby-doc</dfn>, discussing <em>documentation standards and tools</em> for Ruby.</li></ul>
    Messages in ruby-talk ML and <a href="news:comp.lang.ruby">comp.lang.ruby</a> (See <a href="http://rubyhacker.com/clrFAQ.html">FAQ</a>) are replicated via a ML-NetNews gateway each other.
    Official Lists
    To subscribe to a mailing list,
    please send a mail with the following <em>mail body (not the subject)</em>:
    <pre>    subscribe Your-First-Name Your-Last-Name</pre>
    e.g.
    <pre>    subscribe Joseph Smith</pre>
    to the automated "controller" address.
    <ul>
    <li>For the <em>ruby-talk</em> list, the controller address is <a href="mailto:ruby-talk-ctl@ruby-lang.org">ruby-talk-ctl@ruby-lang.org</a>,
    the posting address is <a href="mailto:ruby-talk@ruby-lang.org">ruby-talk@ruby-lang.org</a>,
    and the human administrator address is <a href="mailto:ruby-talk-admin@ruby-lang.org">ruby-talk-admin@ruby-lang.org</a>.
    <li>For the <em>ruby-core</em> list, the controller address is <a href="mailto:ruby-core-ctl@ruby-lang.org">ruby-core-ctl@ruby-lang.org</a>,
    the posting address is <a href="mailto:ruby-core@ruby-lang.org">ruby-core@ruby-lang.org</a>,
    and the "human" administrator address is <a href="mailto:ruby-core-admin@ruby-lang.org">ruby-core-admin@ruby-lang.org</a>.
    <li>For the <em>ruby-doc</em> list, the controller address is <a href="mailto:ruby-doc-ctl@ruby-lang.org">ruby-doc-ctl@ruby-lang.org</a>,
    the posting address is <a href="mailto:ruby-doc@ruby-lang.org">ruby-doc@ruby-lang.org</a>,
    and the "human" administrator address is <a href="mailto:ruby-doc-admin@ruby-lang.org">ruby-doc-admin@ruby-lang.org</a>.</ul>
    To <em>unsubscribe</em> from a list, send a mail which body is "unsubscribe" to the controller address.
    To see the list of <em>commands</em>, send a mail which body is "help" to the controller address.
    You can read <em>archived mails</em> at the past mail archive site: <a href="http://blade.nagaokaut.ac.jp/ruby/ruby-talk/index.shtml">ruby-talk</a> / <a href="http://blade.nagaokaut.ac.jp/ruby/ruby-core/index.shtml">ruby-core</a>.  ruby-talk list has <a href="http://www.ruby-talk.org/">another archive</a>.
    Check <dfn><a href="http://www.rubygarden.org/rurl/html/index.html">Ruby Weekly News</a></dfn> to see what happend in the last week in ruby-talk.
    CVS List
    Want to receive <em>CVS commit</em> mails?
    Subscribe to the <dfn>ruby-cvs</dfn> list, which controller address is <a href="mailto:ruby-cvs-ctl@ruby-lang.org">ruby-cvs-ctl@ruby-lang.org</a>.
    Japanese Lists
    Want to know what Japanese are/have been discussing?
    Try machine translation by <a href="http://babelfish.altavista.com/">Altavista - World / Translate</a> translation service.
    <ul>
    <li><a href="http://babelfish.altavista.com/urltrurl?url=http%3A%2F%2Fblade.nagaokaut.ac.jp%2Fruby%2Fruby-list%2Findex.shtml&doit=done&lp=ja_en&tt=url&urltext=">ruby-list</a>, the senior Ruby mailing list in Japanese.
    <li><a href="http://babelfish.altavista.com/urltrurl?url=http%3A%2F%2Fblade.nagaokaut.ac.jp%2Fruby%2Fruby-dev%2Findex.shtml&doit=done&lp=ja_en&tt=url&urltext=">ruby-dev</a>, the <em>developers</em>' mailing list.
    (Recent threads are <em>summarized in English</em> almost once a week; here is <a href="http://i.loveruby.net/en/ruby-dev-summary.html">the lists</a>.)
    <li><a href="http://babelfish.altavista.com/urltrurl?url=http%3A%2F%2Fblade.nagaokaut.ac.jp%2Fruby%2Fruby-ext%2Findex.shtml&doit=done&lp=ja_en&tt=url&urltext=">ruby-ext</a>, the mailing list for <em>extension</em> developers.
    <li><a href="http://babelfish.altavista.com/urltrurl?url=http%3A%2F%2Fblade.nagaokaut.ac.jp%2Fruby%2Fruby-math%2Findex.shtml&doit=done&lp=ja_en&tt=url&urltext=">ruby-math</a>, the mailing list for <em>mathematical</em> topics.
    </ul>
    Other lists
    <ul>
    <li>There's a <em>French</em> ruby mailing list. Send a subscription request to <a href="mailto:ruby-fr-ctl@ruby-lang.org">ruby-fr-ctl@ruby-lang.org</a>.
    <li>There's an <em>announcement</em> mailing list, <a href="http://lists.rubynet.org/lists/listinfo/rubynet-announce">announce@rubynet.org</a>, for people who want to stay up to date with ruby module releases and other announcements.
    Follow the link on the page for subscription and archive details.   This is a moderated low traffic list for announcements only.</li>
    <li>There's a <em>Portuguese</em> ruby mailing list, hosted at <a href="http://www.listas.unicamp.br/mailman/listinfo/ruby-l">http://www.listas.unicamp.br/mailman/listinfo/ruby-l</a>.
    </ul>
    Caution
    If your mail box/server has rejected mails or caused bounces repeatedly, we may suspend the subscription without notice.  In that case, make sure the problem is gone or fixed and subscribe again.
    You can check the subscription status by sending a mail which body is "status" to the controller address(es).  The commands to resume and suspend a subscription are "on" and "off", respectively. (Only applicable to the lists run by ruby-lang.org)

  :date: "20020104"
  :title: Ruby Mailing Lists
  :author: ""
- :content: |
    <dl>
    <dt><%=my '20020104', 'Mailing list'%></dt>
    <dd>English speaking mailing lists to talk about Ruby.</a></dd>
    <dt>Newsgroup</dt>
    <dd>Messages in ruby-talk mailing lists and USENET newsgroup <a href="news:comp.lang.ruby">comp.lang.ruby</a> (See <a href="http://rubyhacker.com/clrFAQ.html">FAQ</a>) are replicated via a gateway.</dd>
    <dt>IRC (chat) channel</dt>
    <dd>Join other Rubyists for chat on the
    <a href="irc://irc.freenode.net/ruby-lang">#ruby-lang channel</a>
    on freenode.net.  You can also read <a href="http://meme.b9.com">logs of the channel</a>.</dd>
    <dt><a href="http://www.rubygarden.org/ruby?RubyUserGroups">User Groups</a></dt>
    <dd>If you want to get together with fellow Rubyists, Rubicians, or whatever, add a location below, and then put some contact details on the page it points to.</dd>
    <dt><%=my '20020108', 'Conference'%></dt>
    <dd>Conferences include the <a href="http://www.rubyconf.org">Int'l Ruby Conference</a> and the <a href="http://www.approximity.com/euruko03/slides/">European Ruby Conference</a>(EuRuKo)</dd>
    <dt><%=my '20020110', 'Testimonials'%></dt>
    <dd>We are waiting your impression about Ruby.</dd>
    <dt><a href="http://www.ruby-forum.com">Ruby Forum</a></dt>
    <dd>Bulletin board for discussing Ruby.</dd>
    </dl>

  :date: "20020105"
  :title: Community
  :author: ""
- :content: |
    The source code of Ruby is stored in CVS repositories. You can walk them around by CVSweb:
    <ul><li></li><li><a href="http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/">http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/</a></li></ul>
    -->
    That's all, folks! Happy hacking!

  :date: "20020106"
  :title: Ruby CVS Repository Guide
  :author: ""
- :content: |
    <ul>
    <li><a href="ftp://ftp.ruby-lang.org/pub/ruby/doc/ruby-man-1.4.6.tar.gz">Ruby 1.4.6 Reference Manual</a></li>
    <li>English reference manual for Ruby 1.6 is not yet prepared.
    See <a href="http://www.rubycentral.com/ref/index.html">Ruby 1.6 Library reference</a> online.</li>
    <li><a href="http://www.ruby-doc.org">Ruby-doc.org</a> accumulates Ruby-related documents widely.</li>
    <li>Recently, <a href="http://www.ruby-doc.org/stdlib">stdlib-doc project</a> accumulates RDoc-based documents for Ruby standard libraries widely.</li>
    </ul>

  :date: "20020107"
  :title: Downloadable documents
  :author: ""
- :content: |
    <dl>
    <dt><dfn><a href="http://www.rubyconf.org/">RubyConf</a></dfn></dt>
    <dd>Annual Ruby Conference in the U.S.
    <ul>
    <li><dfn><a href="http://www.chadfowler.com/rubyconf.html">RubyConf.new(2001)</a></dfn> by Chad Fowler</li>
    <li><dfn><a href="http://www.zenspider.com/Languages/Ruby/RubyConf2002/">RubyConf.new(2002)</a></dfn> by Ryan Davis & Zen Spider Software</li>
    <li><dfn><a hef="http://www.zenspider.com/Languages/Ruby/RubyConf2003.html">RubyConf.new(2003)</a></dfn> by Ryan Davis & Zen Spider Software</li>
    </ul>
    </dd>
    <dt><dfn><a href="http://www.approximity.com/cgi-bin/europeRuby/tiki.cgi?c=v&p=EuropeanRubyConference">EuRuKo</a></dfn></dt>
    <dd>Ruby Conference in Europe (<em>Eu</em>ropaeische <em>Ru</em>by <em>Ko</em>nferenz).
    <ul>
    <li><dfn>First European Ruby Conference</dfn> (from Saturday 21th to Sunday 22th June, at the University of Karslruhe in Germany): <a href="http://www.approximity.com/euruko03/slides">Slides amd photos</a></li></ul>
    </dd>
    </dl>

  :date: "20020108"
  :title: Conferences
  :author: ""
- :content: |
    Please send a mail to "security@ruby-lang.org":mailto:security@ruby-lang.org to report security issues.
    Reported problems will be published after fixes.

  :date: "20020201"
  :title: Report Security Issues
  :author: ""
- :content: |
    <dl>
    <dt><a href="http://dmoz.org/Computers/Programming/Languages/Ruby/">dmoz.org: Top: Computers: Programming: Languages: Ruby</a></dt>
    <dd>Links, arranged with comment in dmoz: open directory project.</dd>
    <dt><a href="http://www.ruby-lang.org/en/hotlinks.html">Ruby Hotlinks</a></dt>
    <dd>Chronologically sorted links of the newest, freshest, most up-to-date Ruby resources.</dd>
    <dt><a href="http://www.rubygarden.org/ruby">RubyGarden Wiki</a></dt>
    <dd>Yet another Ruby home page which collects great ruby resources.</dd>
    <dt><a href="http://www.rubygarden.org/ruby?RubyBookList">RubyBookList</a></dt>
    <dd>Ruby related books list in RubyGarden Wiki.</dd>
    <dt><%= my('20020307', 'Ruby Around The World') %></dt>
    <dd>Portal links to the site in other languages.</dd>
    <dt><a href="http://www.rubyweeklynews.org/">Ruby Weekly News</a></dt>
    <dd>What happened in the last week in ruby-talk ML.  Produced by Pat Eyler and Holden Glova.</dd>
    </dl>

  :date: "20020308"
  :title: Links
  :author: ""
- :content: |
    <p>The new stable version <a href="ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.6.7.tar.gz">1.6.7</a> is released.</p>

  :date: "20020301"
  :title: 1.6.7 is released
  :author: ""
- :content: |
    Whos are listed in formated as follow:
    <dl>
    <dt>surname "nickname" given-name</dt>
    <dd>any-works</dd>
    </dl>
    To add or correct, mail to <a href="mailto:webmaster@ruby-lang.org">webmaster@ruby-lang.org</a>.
    <dl>
    <dt>Akaishi &quot;freak&quot; <a href="http://ruby.freak.ne.jp/">[web]</a></dt>
    <dd>ML Topics maintainer</dd>
    <dt>Andou <a href="http://www.is.hallab.co.jp/~ando/">[web]</a></dt>
    <dd>mid2slg (MIDI to TEXT)</dd>
    <dt>Aoki Minero <a href="http://www1.u-netsurf.ne.jp/~brew/mine/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Racc">Racc</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=TMail">TMail</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=net">net</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=strscan">strscan</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=textbuf">textbuf</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=amstd">amstd</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=setup.rb">setup.rb</a></dd>
    <dt>Aoyama Wakou</dt>
    <dd>cgi, simple_chat_server, nif</dd>
    <dt>Arai Koji <a href="http://www.ns103.net/~arai/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FTk%20Reference%20Manual">Ruby/Tk Reference Manual</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%20Reference%20Manual%20%28RD%29">Ruby Reference Manual (RD)</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%20Reference%20Manual%20%28Texinfo%29">Ruby Reference Manual (Texinfo)</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%20Reference%20Manual%20%28Texinfo%20English%29">Ruby Reference Manual (Texinfo English)</a></dd>
    <dt>Arai Koji</dt>
    <dd>Ruby/Tk reference manual</dd>
    <dt>ARIMA Yasuhiro <a href="http://homepage1.nifty.com/arima/">[web]</a></dt>
    <dd>Entry Package for Win32</dd>
    <dt>arton <a href="http://www.geocities.co.jp/SiliconValley-PaloAlto/9251/">[web]</a></dt>
    <dd>ActiveScriptRuby</dd>
    <dt>Aseltine Jonathan <a href="http://www.cs.umass.edu/~aseltine/">[web]</a></dt>
    <dd>rbison</dd>
    <dt>Ayanosuke <a href="http://ruby.cgi-space.to/">[web]</a></dt>
    <dd>ruby_highlight for Hidemaru</dd>
    <dt>Dai <a href="http://www.minato.net/~j2/">[web]</a> <a href="mailto:MAP2303@mapletown.net">[mail]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby-ORBit">Ruby-ORBit</a></dd>
    <dt>Decoux Guy</dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=PL%2FRuby">PL/Ruby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=bdb">bdb</a></dd>
    <dt>dellin <a href="http://www.din.or.jp/~ogu/">[web]</a></dt>
    <dd>rd2html, VRedit</dd>
    <dt>Dooley Bryce <a href="http://members.xoom.com/badooley/wingkr/">[web]</a></dt>
    <dd>WINGKR (Win32 GUI Kit)</dd>
    <dt>Eda &quot;Paichi&quot; Yukihiko <a href="http://www.nerv.org/eda/ruby/">[web]</a></dt>
    <dd>nwg4 (for dial-up router, NetGenesis4), RubyGONG (voting CGI)</dd>
    <dt>EGUCHI Osamu</dt>
    <dd>patch</dd>
    <dt>Endo Akira</dt>
    <dd>Japanese version of Ruby-FAQ</dd>
    <dt>Fass Jerry <a href="http://dmoz.org/profiles/jerryobject.html">[web]</a></dt>
    <dd>Publicizes Ruby, helps edit English</dd>
    <dt>FUJIMOTO Hisakuni <a href="http://www.imasy.or.jp/~hisa/">[web]</a></dt>
    <dd>gdbm (DBM library using gdbm), Mac OS Ruby , BeOS Ruby</dd>
    <dt>Fujisawa Yasuhiro</dt>
    <dd>ioport</dd>
    <dt>Fukuda Masaki</dt>
    <dd>patch</dd>
    <dt>Fukushima Masaki <a href="http://www.goto.info.waseda.ac.jp/~fukusima/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=swigruby">swigruby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FPython">Ruby/Python</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Pcap">Pcap</a></dd>
    <dt>Funaba Tadayoshi <a href="http://www.funaba.org/en/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=calendar">calendar</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=date2">date2</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=smf">smf</a></dd>
    <dt>GOTO &quot;gotoken&quot; Kentaro <a href="http://www.math.sci.hokudai.ac.jp/~gotoken/">[web]</a></dt>
    <dd>gpv (frontend for gnuplot), &quot;Ruby User's Guide&quot;, <a href="http://raa.ruby-lang.org/list.rhtml?name=xmp">xmp</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Benchmark">Benchmark</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FKAKASI">Ruby/KAKASI</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Crontab">Crontab</a></dd>
    <dt>Hagino &quot;itojun&quot; Jun-ichiro <a href="http://www.itojun.org/">[web]</a></dt>
    <dd>IPv6</dd>
    <dt>HARA Shin-ichiro</dt>
    <dd>mserch (CGI script to search HTML-files), shttpsrv</dd>
    <dt>HATTORI &quot;Pez&quot; Masashi <a href="http://www1.mirai.ne.jp/~gyo/">[web]</a></dt>
    <dd>Simple Chat Server (revised)</dd>
    <dt>HAYASAKA Ryo <a href="http://www.jaist.ac.jp/%7Eryoh/">[web]</a></dt>
    <dd>patch</dd>
    <dt>Hintze &quot;\cle&quot; Clemens</dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=filelock">filelock</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=testsupp">testsupp</a></dd>
    <dt>hirata naoto <a href="http://www.page.sannet.ne.jp/hirata-naoto/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=ruby-intl">ruby-intl</a></dd>
    <dt>HIWADA Kazuhiro <a href="http://easter.kuee.kyoto-u.ac.jp/~hiwada/">[web]</a></dt>
    <dd>Ruby/JIT, <a href="http://raa.ruby-lang.org/list.rhtml?name=rb2c">rb2c</a></dd>
    <dt>Horie Nobuyuki <a href="http://sfns.u-shizuoka-ken.ac.jp/geneng/horie_hp/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FQt">Ruby/Qt</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FKDE">Ruby/KDE</a></dd>
    <dt>Hoshina <a href="http://www.best.com/~hoshina/">[web]</a></dt>
    <dd>Shin-DCUP (RuBBS writer)</dd>
    <dt>Hunt &quot;/\ndy&quot; Andy <a href="http://www.toolshed.com/">[web]</a> <a href="mailto:andy@toolshed.com">[mail]</a></dt>
    <dd>English version of Ruby-FAQ, Forthcoming English Ruby book</dd>
    <dt>Ichikawa Hirotaka</dt>
    <dd>patch</dd>
    <dt>Igarashi Hiroshi <a href="http://www.ueda.info.waseda.ac.jp/~igarashi/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FGTK">Ruby/GTK</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=lv">lv</a></dd>
    <dt>IKARASHI Akira</dt>
    <dd>ChaSen</dd>
    <dt>Imanaka <a href="http://www.nakky.forus.or.jp/">[web]</a></dt>
    <dd>Today's TV Program</dd>
    <dt>Inaba Hiroto</dt>
    <dd>patch</dd>
    <dt>inachi <a href="http://www.interq.or.jp/earth/inachi/gtk/">[web]</a></dt>
    <dd>Ruby/GNOME</dd>
    <dt>Inoue Hiroshi</dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=RPM-calculator%2FGTK">RPM-calculator/GTK</a></dd>
    <dt>Ishitsuka Keiju</dt>
    <dd>irb, o_dbm</dd>
    <dt>ITO Akinori <a href="http://ei5nazha.yz.yamagata-u.ac.jp/">[web]</a></dt>
    <dd>emie (mail reader), extmath, mdarray, pty</dd>
    <dt>Izawa Kazuhiko</dt>
    <dd>patch</dd>
    <dt>Kaneko Naoshi</dt>
    <dd>patch</dd>
    <dt>Kanemitsu Masao <a href="http://www.ne.jp/asahi/masao-k/home/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Mandel">Mandel</a></dd>
    <dt>Kasahara Motoyuki <a href="http://www.sra.co.jp/people/m-kasahr/">[web]</a></dt>
    <dd>getoptlong, mimeencoder</dd>
    <dt>Kasahara Norio <a href="http://www.linkclub.or.jp/~kasa/">[web]</a></dt>
    <dd>Ruby/Informix</dd>
    <dt>KAWAMURA Takao</dt>
    <dd>patch</dd>
    <dt>Kikutani <a href="http://kondara.sdri.co.jp/~kikutani/">[web]</a></dt>
    <dd>slanglib</dd>
    <dt>KIMURA Koichi <a href="http://www.kt.rim.or.jp/~kbk/">[web]</a></dt>
    <dd>ruby/mswin32</dd>
    <dt>kjana <a href="http://www.os.xaxon.ne.jp/~kjana/">[web]</a></dt>
    <dd>rlex, rpg</dd>
    <dt>Kobayashi Shigeo <a href="http://www.tinyforest.gr.jp/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=BigFloat%20">BigFloat </a></dd>
    <dt>KODAMA &quot;kdm&quot; Kouji <a href="http://www.math.kobe-u.ac.jp/HOME/kodama/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Polynomial">Polynomial</a></dd>
    <dt>Komatsu Katsuyuki</dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=cvsget.rb">cvsget.rb</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=html-parser">html-parser</a></dd>
    <dt>Kosimizu Tomoyuki <a href="http://www02.so-net.ne.jp/~greentea/">[web]</a></dt>
    <dd>Ruby Who's Who maintainer</dd>
    <dt>Kuroda Jun</dt>
    <dd>ICQ (for libicq)</dd>
    <dt>Kuwabara &quot;Tosh&quot; Toshiro <a href="http://www2.pos.to/~tosh/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=RDtool">RDtool</a></dd>
    <dt>M.Suzuki <a href="http://www.geocities.co.jp/SiliconValley-PaloAlto/7276/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Simple%20Calculator%2FGTK">Simple Calculator/GTK</a></dd>
    <dt>Maebashi Takahiro</dt>
    <dd>mine, html-parser, http-access</dd>
    <dt>Maeda Shugo <a href="http://www.netlab.co.jp/~shugo/">[web]</a></dt>
    <dd>java-module, monitor, readline, ftplib, <a href="http://raa.ruby-lang.org/list.rhtml?name=ftpup">ftpup</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=eRuby">eRuby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=mod_ruby">mod_ruby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=rskkserv">rskkserv</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=JED%2FRuby">JED/Ruby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=VIM%2FRuby">VIM/Ruby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=libwrap-ruby">libwrap-ruby</a></dd>
    <dt>Masuda &quot;Sharl&quot; Kazuya <a href="http://sharl.hauN.org/d/">[web]</a></dt>
    <dd>patch</dd>
    <dt>Matsumoto &quot;matz&quot; Yukihiro <a href="http://www.ruby-lang.org/">[web]</a> <a href="mailto:matz@netlab.co.jp">[mail]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby">Ruby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=interbase">interbase</a></dd>
    <dt>Matsumoto Eiji</dt>
    <dd>sha (secure hash)</dd>
    <dt>Matsuo Hisanori</dt>
    <dd>HttpTunnel, Meeting2000, <a href="http://raa.ruby-lang.org/list.rhtml?name=Petit%2BServer">Petit+Server</a></dd>
    <dt>Michel &quot;Hipster&quot; van de Ven</dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=depends">depends</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=httpd">httpd</a></dd>
    <dt>MOF <a href="http://www.geocities.co.jp/SiliconValley-PaloAlto/8421/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=cannaTool">cannaTool</a></dd>
    <dt>Murray T. Arthur</dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Mind.Ruby">Mind.Ruby</a></dd>
    <dt>MUSHA &quot;knu&quot; Akinori</dt>
    <dd>CVS administrator, Maintainer of 100+ <a href="http://www.FreeBSD.org/ports/ruby.html">Ruby related FreeBSD ports</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=cvsmailer">cvsmailer</a></dd>
    <dt>Nagai Hidetoshi</dt>
    <dd>Ruby/Tk maintainer, <a href="http://raa.ruby-lang.org/list.rhtml?name=TclTk-Ext">TclTk-Ext</a></dd>
    <dt>Nagasawa Kenji</dt>
    <dd>patch</dd>
    <dt>Nagasawa Kenji <a href="http://member.nifty.ne.jp/~kenn/">[web]</a></dt>
    <dd>ruby binary for OS/2</dd>
    <dt>Nakajima &quot;ringo&quot; Kengo <a href="http://www.hompo.co.jp/~ringo/">[web]</a></dt>
    <dd>Automatic Translation Project, <a href="http://raa.ruby-lang.org/list.rhtml?name=cvsmailer">cvsmailer</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=ringo%27s%20auto%20bookmark">ringo's auto bookmark</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=ringo%27s%20auto%20addressbook">ringo's auto addressbook</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=ringo%27s%20auto%20white%20board">ringo's auto white board</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=cvsmailer">cvsmailer</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=wwwd+-+fast+ruby+webserver">wwwd+-+fast+ruby+webserver</a></dd>
    <dt>Nakamura &quot;GuionShouja&quot; Akifumi <a href="http://member.nifty.ne.jp/guion/">[web]</a></dt>
    <dd>PocketBSD Ruby, <a href="http://raa.ruby-lang.org/list.rhtml?name=RubyMgl">RubyMgl</a></dd>
    <dt>NAKAMURA &quot;NaHi&quot; Hiroshi <a href="http://www.jin.gr.jp/~nahi/">[web]</a></dt>
    <dd>HotLinks maintainer, <a href="http://raa.ruby-lang.org/list.rhtml?name=TCPSocketPipe">TCPSocketPipe</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Scarlet">Scarlet</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=SOAP4R">SOAP4R</a></dd>
    <dt>Nakamura Noritsugu <a href="http://www2s.biglobe.ne.jp/~Nori/">[web]</a></dt>
    <dd>AnimX I/F, Ruby/Tk-FAQ, <a href="http://raa.ruby-lang.org/list.rhtml?name=libplot">libplot</a>, <a href="http://www.ruby-lang.org/en/raa.html#Ruby%2Fkcc">http://www.ruby-lang.org/en/raa.html#Ruby/kcc</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2Flibjcode">Ruby/libjcode</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FWKF">Ruby/WKF</a></dd>
    <dt>Neumann Michael <a href="http://www.s-direktnet.de/homepages/neumann/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=favs2html">favs2html</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=CAST-256">CAST-256</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=LinkChecker">LinkChecker</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Whois">Whois</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=edf">edf</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=i386-mswin32">i386-mswin32</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Soundex">Soundex</a></dd>
    <dt>Nishi &quot;buchikire&quot; Kazunori <a href="http://kazu.nori.org/news/">[web]</a></dt>
    <dd>patch</dd>
    <dt>Nishikawa &quot;nyasu&quot; Yasuhiro <a href="http://www.threeweb.ad.jp/~nyasu/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=PalmSync">PalmSync</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=RubyEB">RubyEB</a></dd>
    <dt>nobu.nakada <a href="http://member.nifty.ne.jp/nokada/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=iconv">iconv</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=OptionParser">OptionParser</a></dd>
    <dt>Nomura Yoshinari <a href="http://www.swlab.csce.kyushu-u.ac.jp/~nom/">[web]</a></dt>
    <dd>mhc (scheduler and its library)</dd>
    <dt>nosuzuki <a href="http://www.lares.dti.ne.jp/~nosuzuki/">[web]</a></dt>
    <dd>NNTP-server, NNTP-client</dd>
    <dt>not <a href="http://www14.cds.ne.jp/~not/">[web]</a></dt>
    <dd>nDiary</dd>
    <dt>Oda Koji</dt>
    <dd>patch</dd>
    <dt>OHBA Yasuo</dt>
    <dd>lib/parsearg, lib/getopts</dd>
    <dt>Okabe Katsuyuki</dt>
    <dd>patch</dd>
    <dt>OKUNISHI Fujikazu <a href="http://web.kyoto-inet.or.jp/people/fuji0924/">[web]</a></dt>
    <dd>patch</dd>
    <dt>OZAWA &quot;Crouton&quot; Sakuro <a href="http://www.duelists.org/~crouton/">[web]</a></dt>
    <dd>Ruby-FAQ (SGML version)</dd>
    <dt>rubikitch <a href="http://www.oishi.info.waseda.ac.jp/~takashi/">[web]</a> <a href="mailto:rubikitch@ruby-lang.org">[mail]</a></dt>
    <dd>Ruby-Math maintainer, ruby-info.el, <a href="http://raa.ruby-lang.org/list.rhtml?name=RDindex">RDindex</a></dd>
    <dt>Saitou Noboru <a href="http://webclub.kcom.ne.jp/mb/noborus/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=postgres">postgres</a></dd>
    <dt>SASAKI Shunsuke <a href="http://www3.justnet.ne.jp/~ele/">[web]</a></dt>
    <dd>epp (Easy PreProcessor)</dd>
    <dt>Sasse Hugh G. <a href="http://www.eng.cse.dmu.ac.uk/~hgs/">[web]</a></dt>
    <dd><a href="http://www.eng.cse.dmu.ac.uk/~hgs/ruby/ruby-man-1.4/a2zindexhtml">A-Z index of the Manual</a></dd>
    <dt>Satou Soutarou</dt>
    <dd>scnt (smart counter for CGI), html</dd>
    <dt>Schneiker Conrad <a href="http://www.jump.net/~schneiker/  not available yet">[web]</a></dt>
    <dd>Proponent of comp.lang.ruby, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FTk+GUI+builder+--+specRuby">Ruby/Tk+GUI+builder+--+specRuby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FTk+Widget+Demos">Ruby/Tk+Widget+Demos</a></dd>
    <dt>SEKI Masatoshi <a href="http://www2a.biglobe.ne.jp/~seki/">[web]</a></dt>
    <dd>ruby-servlet, ruby/FileMaker, sigidx, <a href="http://raa.ruby-lang.org/list.rhtml?name=ERb%20---%20Tiny%20eRuby">ERb --- Tiny eRuby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=druby%20---%20distributed%20ruby">druby --- distributed ruby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=acl">acl</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=MutexM">MutexM</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=tuplespace">tuplespace</a></dd>
    <dt>Shigehiro Yuji <a href="http://www.oit.ac.jp/www-ee/islab/member/sigehiro/">[web]</a></dt>
    <dd>ext/tcltklib</dd>
    <dt>Shigihara Atsuhiro <a href="http://www.sgmail.org/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=SGmail">SGmail</a></dd>
    <dt>Shiida Kazuya <a href="http://lenz.pos.to/">[web]</a></dt>
    <dd>Ruby-chan (candidate release), Page designer of www.ruby-lang.org</dd>
    <dt>SHIMOKAWA Toshihiko</dt>
    <dd>patch</dd>
    <dt>SHIROYAMA Takayuki</dt>
    <dd>patch</dd>
    <dt>Shoji &quot;yashi&quot; Yasushi <a href="http://kafka.salemstate.edu/~yashi/ruby/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Glade%2FRuby">Glade/Ruby</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FGdkPixbuf">Ruby/GdkPixbuf</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FGtkGLArea">Ruby/GtkGLArea</a></dd>
    <dt>SHUDO Kazuyuki <a href="http://www.shudo.net/">[web]</a></dt>
    <dd>shuJIT (Just-In-Time compiler for Java)</dd>
    <dt>SRC <a href="http://src.presen.to/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=mn128">mn128</a></dd>
    <dt>Suketa Masaki <a href="http://homepage1.nifty.com/markey/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=RubyWin">RubyWin</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Win32OLE">Win32OLE</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=RubyUnit">RubyUnit</a></dd>
    <dt>Tada &quot;sho&quot; Tadashi <a href="http://www.spc.gr.jp/sho/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=RuBBS">RuBBS</a>, <a href="http://sf.net/projects/tdiary/">tDiary</a></dd>
    <dt>Tadokoro Mitsunori</dt>
    <dd>Ruby for BeOS</dd>
    <dt>Takahashi &quot;HITOPPI&quot; Hitosi <a href="http://www-nh.scphys.kyoto-u.ac.jp/~thitoshi/member.html">[web]</a></dt>
    <dd>PDFlib</dd>
    <dt>TAKAHASHI Masayoshi</dt>
    <dd>patch</dd>
    <dt>Takaishi Tetsuhumi</dt>
    <dd>sybct</dd>
    <dt>TAMURA "tam" Ryuichi</dt>
    <dd>  GD maintainer</dd>
    <dt>Tateishi Takaaki <a href="http://kt-www.jaist.ac.jp:8000/~ttate/">[web]</a></dt>
    <dd>popmail, ruby-xview, frac, Ruby/Tk81 widget-demo, ssl.rb, <a href="http://raa.ruby-lang.org/list.rhtml?name=fep">fep</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FForms">Ruby/Forms</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FFltk">Ruby/Fltk</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=ruby-shadow">ruby-shadow</a></dd>
    <dt>Thomas Dave <a href="http://www.thomases.com/">[web]</a></dt>
    <dd>English version of Ruby-FAQ, Forthcoming English Ruby book</dd>
    <dt>Toki Yosinori <a href="http://www.freedom.ne.jp/toki/">[web]</a></dt>
    <dd>perllib, <a href="http://raa.ruby-lang.org/list.rhtml?name=rmp3">rmp3</a></dd>
    <dt>Tomita &quot;tommy&quot; Masahiro <a href="http://www.tmtm.org/">[web]</a></dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=MySQL%2FRuby">MySQL/Ruby</a></dd>
    <dt>Tsukada Takuya</dt>
    <dd>patch</dd>
    <dt>Tsuruoka Nobuhiko</dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=SNMP">SNMP</a></dd>
    <dt>Ueno Katsuhiro</dt>
    <dd><a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2Fzlib">Ruby/zlib</a></dd>
    <dt>WATANABE Hirofumi</dt>
    <dd>DOS Ruby, ruby/cygwin</dd>
    <dt>WATANABE Tetsuya <a href="http://homepage1.nifty.com/~tetsu/">[web]</a></dt>
    <dd>mkprof (a profiler)</dd>
    <dt>yamada akira <a href="http://arika.org/">[web]</a></dt>
    <dd>ruby.deb maintainer</dd>
    <dt>Yasu.F <a href="http://www8.big.or.jp/~yasuf/">[web]</a></dt>
    <dd>yacgi, FreeBSD Ruby</dd>
    <dt>Yoshi <a href="http://www2.giganet.net/~yoshi/">[web]</a></dt>
    <dd>Togl Widget Class, ImageMagick Module (under construction), <a href="http://raa.ruby-lang.org/list.rhtml?name=OpenGL%20Interface">OpenGL Interface</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Math3d">Math3d</a></dd>
    <dt>YOSHIDA &quot;Moriq&quot; Kazuhiro <a href="http://www.users.yun.co.jp/~moriq/">[web]</a></dt>
    <dd>Apollo (Delphi Ruby Interface), <a href="http://raa.ruby-lang.org/list.rhtml?name=fv.rb">fv.rb</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=adv">adv</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=rbdoc">rbdoc</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=RGUI">RGUI</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FXlib">Ruby/Xlib</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Ruby%2FFreeType">Ruby/FreeType</a></dd>
    <dt>Yoshida &quot;yoshidam&quot; Masato <a href="http://www.bekkoame.ne.jp/~yoshidam/">[web]</a></dt>
    <dd>perl, VFlib, syslog, <a href="http://raa.ruby-lang.org/list.rhtml?name=oracle">oracle</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Unicode">Unicode</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Uconv">Uconv</a>, <a href="http://raa.ruby-lang.org/list.rhtml?name=Susie%20Plugin">Susie Plugin</a>, <a href="http://raa.raby-lang.org/list.rhtml?name=XMLParser">XMLParser</a></dd>
    </dl>

  :date: "20020305"
  :title: Who's Who
  :author: ""
- :content: |
    <ul>
    <li><%=my "20020305", "Who's Who"%></li>
    </ul>

  :date: "20020306"
  :title: Expired article
  :author: ""
- :content: |
    <p>Links to the site in other languages.</p>
    <ul>
    <li><a href="http://www.s-direktnet.de/homepages/neumann/rb/index.html">Features of Ruby</a> - In German.</li>
    <li><a href="http://home.swipnet.se/pelewin/ruby/">Programmering i Ruby</a> - In Swedish.</li>
    <li><a href="http://www.e.kth.se/unix-systemet/admin/ruby/">Rubyadmins informationssida</a> - Emacs tips in Swedish.</li>
    <li><a href="http://www.xs4all.nl/~jjacobs/index.html">Dutch translation of www.ruby-lang.org</a>.</li>
    <li><a href="http://cafe.naver.com/ruby/">Korean translation of www.ruby-lang.org</a>.</li>
    <li><a href="http://rubycn.ce-lab.net/">Chinese translation of www.ruby-lang.org</a>.</li>
    </ul>

  :date: "20020307"
  :title: Ruby Around The World
  :author: ""
- :content: |
    <p><a href="http://www.xs4all.nl/~jjacobs/index.html">Dutch translation of www.ruby-lang.org</a> is available.
    Thanks to John Jacobs.</p>

  :date: "20020918"
  :title: Dutch translation of www.ruby-lang.org
  :author: ""
- :content: |
    <p>We www-admin@ruby-lang.org rewrote current <a href="http://raa.ruby-lang.org/">RAA</a> which got a little old and rickety.</p>
    <p>Changes:</p>
    <ul>
    <li>lightweight top page</li>
    <li>iso8859-1 => UTF-8</li>
    <li>added simple keyword search</li>
    <li>show projects by the specified owner</li>
    </ul>
    <p>SOAP and XML-RPC interfaces will be updated, too. Users of RAA SOAP and XML-RPC interfaces, please tell me if the problem occurred.  I changed wire format a little.  See below;</p>
    <ul>
    <li>id and owner_id element are added to each entry.
    Those two elements contain positive integer.</li>
    <li>For SOAP interface users only: element url, download
    and email are marked as xsd:anyURI type.  Those
    elements will be unmarshalled as a URI object at
    client side, not a String object.</li>
    </ul>
    <p>Except SOAP and XML-RPC we are offering a plain XML or RDF file of RAA information.  Those are at http://raa.ruby-lang.org/xml.xml and http://raa.ruby-lang.org/rdf.xml.  You can also get recent information in RDF format from http://raa.ruby-lang.org/since.mrb</p>
    <p>Users of pragdave's XML/RDF feed interfaces should use above for a while.  Pragdave's former interfaces are not updated now because of replacing RAA DB.  Bare in mind some changes are made to these interfaces, too.  See below;</p>
    <ul>
    <li>*.xml files are updated in each 15 minutes, not on the
    fly.</li>
    <li>Charset encoding scheme was changed from iso-8859-1 to
    UTF-8.</li>
    <li>XML instance format is changed for user's convenience.</li>
    </ul>

  :date: "20021024"
  :title: RAA replaced
  :author: ""
- :content: |
    <p>(Excerpted from
    <a href="http://www.rubygarden.org/ruby?RubyIn2002">http://www.rubygarden.org/ruby?RubyIn2002</a>.)</p>
    <p>The second annual Ruby Conference was held in November 2002 in Seattle, WA, USA.</p>
    <p>
    There were about fifteen presentations, as well as a keynote speech by Matz.</p>
    <p>Slides of the talks are available at
    <a href="http://www.zenspider.com/Languages/Ruby/RubyConf2002/">http://www.zenspider.com/Languages/Ruby/RubyConf2002/</a>.</p>

  :date: "20021101"
  :title: <%=my('20021101', 'Ruby Conference 2002')%>
  :author: NaHi
- :content: |
    <p>Now you can get Ruby Installer For Windows from <a href="http://rubyinstaller.sourceforge.net/">http://rubyinstaller.sourceforge.net/</a>.</p>
    <p>Excerpted from the site.</p>
    <pre>
    This is a "one-click", self-contained installer that
    comprises the Ruby language itself, dozens of popular
    extensions and packages, a syntax-highlighting editor
    and execution environment, and a Windows help file that
    contains the full text of the book, "Programming Ruby:
    The Pragmatic Programmer's Guide". 
    </pre>
    <p>It's a must item for Ruby users on Win32 box.
    Check also
    <a href="http://www.dm4lab.to/~usa/ruby/index_en.html#download">usa's binaries</a> and
    <a href="http://www.ruby-lang.org/~eban/ruby/binaries/">eban's win32 binaries</a> to get Win32 binaries with dozens of popular extensions. </p>

  :date: "20021125"
  :title: Ruby Installer For Windows at sourceforge
  :author: NaHi
- :content: |
    <p><a href="http://direct.ips.co.jp/book/Template/Goods/go_BookstempGR.cfm?GM_ID=1721&amp;SPM_ID=1&amp;CM_ID=004000G20&amp;PM_No=&amp;PM_Class=&amp;HN_NO=00420"><img class="icon" src="http://direct.ips.co.jp/directsys/Images/Goods/1/1721B.gif" alt="RHG" width="70" height="88"></a>
    A book named "Ruby source code Kanzen Kaisetsu - Ruby Hacking Guide"
    by Aoki-san is out though it's written in Japanese...</p>
    <p>
    It's a must-buy item for Ruby hacker, who can read Japanese. :(</p>
    <ul>
    <li>Publisher: Impress</li>
    <li>Author: AOKI, Minero under the editorship of MATSUMOTO, Yukihiro</li>
    <li>ISBN: 4-8443-1721-0</li>
    </ul>
    <p>I tried to translate the table of contents below.
    Bear in mind that it's an unofficial translation.</p>
    <pre>
    Preface
    i      Target reader
    ii     Construction of this book
    iii    Environment
    ix     Web site
    x      Thanks
    0      Preface
    0.1    The characteristics of Ruby
    0.2    How to hack source code
    0.2.1  Principle
    0.2.2  Analytic technique
    0.2.3  Dynamic analysis
    0.2.4  Static analysis
    0.2.5  History knows everything
    0.2.6  Tool for static analysis
    0.3    Build
    0.3.1  Version
    0.3.2  Getting the source code
    0.3.3  Compile
    0.4    Build details
    0.4.1  configure
    0.4.2  autoconf
    0.4.3  make
    0.5    CVS
    0.5.1  Teach yourself CVS in 50 lines
    0.6    The construction of ruby source code
    0.6.1  Physical structure
    0.6.2  Dividing the source code
    0.6.3  Logical structure
    Chapter I: Object
    1.     Ruby language minimum
    1.1    Object
    1.1.1  String
    1.1.2  Various literals
    1.1.3  Method call
    1.2    Program
    1.2.1  Top-level
    1.2.2  Local variable
    1.2.3  Constant variable
    1.2.4  Control structure
    1.3    Class and method
    1.3.1  Class
    1.3.2  Class definition
    1.3.3  Method definition
    1.3.4  self
    1.3.5  Instance variable
    1.3.6  Initialize
    1.3.7  Inheritance
    1.3.8  Variable inheritance ... ?
    1.3.9  Module
    1.4    Program II
    1.4.1  Nested constant
    1.4.2  Everything is evaluated
    1.4.3  Scope of local variable
    1.4.4  self as a context
    1.4.5  Loading
    1.5    About the class, more
    1.5.1  About constant continues
    1.5.2  Meta-class
    1.5.3  Meta-object
    1.5.4  Singleton method
    1.5.5  Class variable
    1.6    Global variable
    2.     Object
    2.1    The structure of the Ruby object
    2.1.1  Guidelines
    2.1.2  VALUE and object structure
    2.1.3  Embedded objects in VALUE
    2.2    Method
    2.2.1  struct RClass
    2.2.2  Method search
    2.3    Instance variable
    2.3.1  rb_ivar_set()
    2.3.2  generic_ivar_set()
    2.3.3  Gap in the structure
    2.3.4  rb_ivar_get()
    2.4    Object structure
    2.4.1  struct RString
    2.4.2  struct RArray
    2.4.3  struct RRegexp
    2.4.4  struct RHash
    2.4.5  struct RFile
    2.4.6  struct RData
    3.     Name and name table
    3.1    st_table
    3.1.1  Outline
    3.1.2  Data structure
    3.1.3  Example of st_hash_type
    3.1.4  st_lookup()
    3.1.5  st_add_direct()
    3.1.6  st_insert()
    3.2    ID and symbol
    3.2.1  From char* to ID
    3.2.2  From ID to char*
    3.2.3  Conversion between VALUE and ID
    4.     Class and module
    4.1    Definition of class and method
    4.1.1  Definition of class
    4.1.2  Definition of nested class
    4.1.3  Definition of module
    4.1.4  Definition of method
    4.1.5  Definition of singleton method
    4.1.6  Entry point
    4.2    Singleton class
    4.2.1  rb_define_singleton_method()
    4.2.2  rb_singleton_class()
    4.2.3  Usual class and singleton class
    4.2.4  Compression of rb_singleton_class()
    4.2.5  Compression of rb_make_metaclass()
    4.2.6  What is the singleton class
    4.2.7  Singleton class and instance
    4.2.8  Summary
    4.3    Meta-class
    4.3.1  Inheritance of singleton method
    4.3.2  Singleton class of a class
    4.3.3  The class of the class of the class
    4.3.4  Singleton class and meta-class
    4.3.5  Bootstrap
    4.4    Class name
    4.4.1  Name to class
    4.4.2  Class to name
    4.4.3  Nest level 2 or more
    4.4.4  Anonymous class
    4.5    Include
    4.5.1  rb_include_module (1)
    4.5.2  include_class_new()
    4.5.3  Simulation
    4.5.4  rb_include_module (2)
    5.     Garbage Collection
    5.1    Memory image at runtime
    5.1.1  Segment
    5.1.2  alloca()
    5.2    Outline
    5.2.1  What's GC
    5.2.2  What's done in GC
    5.2.3  Mark &amp; sweep
    5.2.4  Stop &amp; copy
    5.2.5  Reference count
    5.3    Object management
    5.3.1  struct RVALUE
    5.3.2  Object heap
    5.3.3  freelist
    5.3.4  add_heap()
    5.3.5  rb_newobj()
    5.4    Mark
    5.4.1  rb_gc_mark()
    5.4.2  rb_gc_mark_children()
    5.4.3  rb_gc()
    5.4.4  Ruby stack
    5.4.5  Register
    5.4.6  Machine stack
    5.4.7  Other root objects
    5.5    Sweep
    5.5.1  Special treatment for NODE
    5.5.2  Finalizer
    5.5.3  rb_gc_force_recycle()
    5.6    Consideration
    5.6.1  Freeing the memory space
    5.6.2  Generational GC
    5.6.3  Compaction
    5.6.4  volatile, countermeasure for GC
    5.7    The timing of the start
    5.7.1  gc.c inside
    5.7.2  In the interpreter
    5.8    Object allocation
    5.8.1  Allocation framework
    5.8.2  Allocation of user defined object
    5.8.3  The problem of the allocation framework
    6.     Variable and constant
    6.1    Outline of this section
    6.1.1  Variable of Ruby
    6.1.2  Ruby API for the variable
    6.1.3  The point of this section
    6.2    Class variable
    6.2.1  Reference
    6.3    Constant
    6.3.1  Assignment
    6.3.2  Reference
    6.4    Global variable
    6.4.1  General remarks
    6.4.2  Data structure
    6.4.3  Reference
    7.     Security
    7.1    Principle
    7.2    Implementation
    Chapter II: Syntactic analysis
    8.     Ruby language detailed
    8.1    Literal
    8.1.1  String
    8.1.2  Character
    8.1.3  Regular expression
    8.1.4  Array
    8.1.5  Hash
    8.1.6  Range
    8.1.7  Symbol
    8.1.8  Numerical value
    8.2    Method
    8.2.1  Definition and call
    8.2.2  Value of the method
    8.2.3  Omissible argument
    8.2.4  Omission of parenthesis for argument
    8.2.5  Argument and array
    8.2.6  Various call forms
    8.2.7  super
    8.3    Iterator
    8.3.1  Comparison with the higher order function
    8.3.2  Block local variable
    8.3.3  Iterator syntax
    8.3.4  yield
    8.3.5  Proc
    8.4    Expression
    8.4.1  if
    8.4.2  unless
    8.4.3  and &amp;&amp; or ||
    8.4.4  Condition arithmetic operator
    8.4.5  while until
    8.4.6  case
    8.4.7  Exception
    8.4.8  Variable and constant
    8.4.9  Assignment
    8.4.10 Self-assignment
    8.4.11 defined?
    8.5    Sentence
    8.5.1  Terminal of the sentence
    8.5.2  if/unless modifier
    8.5.3  while/until modifier
    8.5.4  Class definition
    8.5.5  Method definition
    8.5.6  Singleton method definition
    8.5.7  Singleton class definition
    8.5.8  Multiple assignment
    8.5.9  alias
    8.5.10 undef
    8.6    Others
    8.6.1  Comment
    8.6.2  Embedded document
    8.6.3  Multibyte character
    9.     yacc in a day
    9.1    Outline
    9.1.1  Parser and scanner
    9.1.2  Symbol sequence
    9.1.3  Parser generator
    9.2    Grammar
    9.2.1  Grammar file
    9.2.2  What yacc does
    9.2.3  BNF
    9.2.4  Terminal and non-terminal symbol
    9.2.5  Test method
    9.2.6  Empty rule
    9.2.7  Recursive definition
    9.3    Building of the value
    9.3.1  Shift and reduce
    9.3.2  Action
    9.3.3  The value of symbol
    9.3.4  yacc and type
    9.3.5  Connecting the parser and the scanner
    9.3.6  Embedded action
    9.4    Realistic topic
    9.4.1  Collision
    9.4.2  Lookahead
    9.4.3  Operator priority order
    10.    Parser
    10.1   Guidelines
    10.1.1 Building of a parser
    10.1.2 Dividing parse.y
    10.2   Grammar rule general remarks
    10.2.1 Coding rule
    10.2.2 Important symbol
    10.2.3 Whole structure
    10.2.4 program
    10.2.5 stmt
    10.2.6 expr
    10.2.7 arg
    10.2.8 primary
    10.2.9 Collision of list
    10.3   Scanner
    10.3.1 Parser rough sketch
    10.3.2 Input buffer
    10.3.3 Token buffer
    10.3.4 yylex()
    10.3.5 String kind
    11.    State scanner
    11.1   Outline
    11.1.1 Concrete example
    11.1.2 lex_state
    11.1.3 Reading state scanner
    11.1.4 About the each state
    11.2   Controlling line feed
    11.2.1 Problem
    11.2.2 Implementation
    11.3   Method name which is in reserved word
    11.3.1 Problem
    11.3.2 Method definition
    11.3.3 Method call
    11.3.4 Symbol
    11.4   Modifier
    11.4.1 Problem
    11.4.2 Implementation
    11.5   The collision of do
    11.5.1 Problem
    11.5.2 The solution at the rule level
    11.5.3 The solution at the symbol level
    11.5.4 COND_P()
    11.6   tLPAREN_ARG (1)
    11.6.1 Problem
    11.6.2 Investigation
    11.6.3 In case of 1 argument
    11.6.4 Case 2 or more arguments
    11.7   tLPAREN_ARG (2)
    11.7.1 Problem
    11.7.2 The solution at the rule level
    11.7.3 {} iterator
    11.7.4 do end iterator
    11.7.5 The fact and truth
    12.    Building of syntax tree
    12.1   Node
    12.1.1 NODE
    12.1.2 Node type
    12.1.3 File name and line number
    12.1.4 rb_node_newnode()
    12.2   Building of syntax tree
    12.2.1 YYSTYPE
    12.2.2 Scenery with a syntax tree
    12.2.3 Leaf
    12.2.4 Branch
    12.2.5 Trunk
    12.2.6 Two lists
    12.3   Semantic analysis
    12.3.1 Error in action
    12.3.2 value_expr()
    12.3.3 The global image of the value check
    12.4   Local variable
    12.4.1 Definition of the local variable
    12.4.2 Block local variable
    12.4.3 Data structure
    12.4.4 Scope of local variable
    12.4.5 push and pop
    12.4.6 Adding a variable
    12.4.7 Summary of local variable
    12.4.8 Block local variable
    12.4.9 ruby_dyna_vars in the parser
    Chapter III: Evaluation
    13.    The structure of the evaluator
    13.1   Outline of Chapter III
    13.1.1 What's evaluator
    13.1.2 The characteristics of the ruby evaluator
    13.1.3 eval.c
    13.2   Going from main through ruby_run to rb_eval
    13.2.1 Call graph
    13.2.2 main()
    13.2.3 ruby_init()
    13.2.4 ruby_options()
    13.2.5 ruby_run()
    13.3   rb_eval()
    13.3.1 Outline
    13.3.2 NODE_IF
    13.3.3 NODE_NEWLINE
    13.3.4 Pseudo local variable
    13.3.5 Jump tag
    13.3.6 NODE_WHILE
    13.3.7 Evaluating value of while
    13.4   Exception
    13.4.1 raise
    13.4.2 Global image
    13.4.3 ensure
    13.4.4 rescue
    14.    Context
    14.1   Ruby stack
    14.1.1 Context and stack
    14.1.2 ruby_frame
    14.1.3 ruby_scope
    14.1.4 ruby_block
    14.1.5 ruby_iter
    14.1.6 ruby_dyna_vars
    14.1.7 ruby_class
    14.1.8 ruby_cref
    14.1.9 PUSH/POP macros
    14.1.10 Other condition
    14.2   Module definition
    14.2.1 Investigation
    14.2.2 NODE_MODULE
    14.2.3 module_setup()
    14.2.4 Building local variable scope
    14.2.5 Allocating local variable memory space
    14.2.6 TMP_ALLOC()
    14.2.7 Changing target of method definition
    14.2.8 Nested class
    14.2.9 Replacing frames
    14.3   Method definition
    14.3.1 Investigation
    14.3.2 NODE_DEFN
    14.3.3 copy_node_scope()
    14.3.4 rb_add_method()
    14.4   Assignment and reference
    14.4.1 Local variable
    14.4.2 Constant
    14.4.3 Class variable
    14.4.4 Multiple assignment
    15.    Method
    15.1   Searching method
    15.1.1 Terminology
    15.1.2 Investigation
    15.1.3 SETUP_ARGS()
    15.1.4 rb_call() 
    15.1.5 Method cash
    15.2   Invocation
    15.2.1 rb_call0()
    15.2.2 PUSH_FRAME()
    15.2.3 rb_call0() -- NODE_CFUNC
    15.2.4 rb_call0() -- NODE_SCOPE
    15.2.5 Setting argument
    15.2.6 super
    16.    Block
    16.1   Iterator
    16.1.1 Global image
    16.1.2 Push block
    16.1.3 Calling iterator method
    16.1.4 Block invocation
    16.1.5 Target designated jump
    16.1.6 Check of block
    16.2   Proc
    16.2.1 Allocating Proc object
    16.2.2 Copying frames
    16.2.3 Proc invocation
    16.2.4 Block and Proc
    17.    Dynamic evaluation
    17.1   Outline
    17.1.1 eval
    17.1.2 module_eval and instance_eval
    17.2   eval
    17.2.1 eval()
    17.2.2 top_local
    17.2.3 Block local variable
    17.3   instance_eval
    17.3.1 Global image
    17.3.2 After inlining
    17.3.3 Before inlining
    Chapter IV: Fringes of the evaluator
    18.    Loading
    18.1   Outline
    18.1.1 Interface
    18.1.2 Flow of the whole management
    18.1.3 Target of this section
    18.2   Library search
    18.2.1 rb_f_require()
    18.2.2 rb_find_file()
    18.2.3 Load wait
    18.3   Loading Ruby program
    18.3.1 rb_load()
    18.3.2 rb_load_file()
    18.4   Loading extension library
    18.4.1 rb_f_require() -- load_dyna
    18.4.2 Review of linking
    18.4.3 Really dynamic linking
    18.4.4 Dynamic loading API
    18.4.5 dln_load()
    18.4.6 dln_load() -- dlopen()
    18.4.7 dln_load()-- Win32
    19.    Thread
    19.1   Outline
    19.1.1 Ruby interface
    19.1.2 ruby thread
    19.1.3 Is it preemptive?
    19.1.4 Control system
    19.1.5 What is thread switch?
    19.1.6 Method of context switch
    19.1.7 Plan of explanation
    19.2   Trigger
    19.2.1 I/O wait
    19.2.2 Waiting other threads
    19.2.3 Time wait
    19.2.4 Switching due to the time expire
    19.3   Scheduling
    19.3.1 rb_thread_schedule()
    19.3.2 select
    19.3.3 Preparation for select
    19.3.4 Calling select
    19.3.5 Deciding the next thread
    19.3.6 Switching thread
    19.4   Context switch
    19.4.1 Basic line
    19.4.2 rb_thread_save_context()
    19.4.3 rb_thread_restore_context()
    19.4.4 Problem
    Final chapter: The future of Ruby
    20.1   Problems to be solved
    20.1.1 Performance of GC
    20.1.2 Parser implementation
    20.1.3 Reusable parser
    20.1.4 Code hiding
    20.1.5 Interpreter object
    20.1.6 Structure of evaluator
    20.1.7 Speed of the evaluator
    20.1.8 Thread implementation
    20.2   ruby2
    20.2.1 Rite
    20.2.2 Description language
    20.2.3 GC
    20.2.4 Parser
    20.2.5 Evaluator
    20.2.6 Thread
    20.2.7 M17N
    20.2.8 IO
    20.3   Ruby Hacking Guide
    20.3.1 Generational GC
    20.3.2 Oniguruma
    20.3.3 ripper
    20.3.4 Substitutive parser
    20.3.5 JRuby
    20.3.6 NETRuby
    20.3.7 How to participate the development of Ruby
    20.3.8 At the end
    Appendix A: Function and macros reference
    Appendix B: References
    Index
    </pre>
    <p></p>

  :date: "20021211"
  :title: "\"Ruby Hacking Guide\" is out though ..."
  :author: NaHi
- :content: |
    <p>I just put the 1.6.8 release package on the ftp.  1.6.8 should be the
    last release in the 1.6.x series.  Check out</p>
    <ul>
    <li><a href="ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.6.8.tar.gz">ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.6.8.tar.gz</a></li>
    </ul>
    <p>I also put the first preview of 1.8.0 at</p>
    <ul>
    <li><a href="ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.0-preview1.tar.gz">ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.0-preview1.tar.gz</a></li>
    <li><a href="ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.0-preview1-errata.diff">ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.0-preview1-errata.diff</a>
    </ul>
    <p>Merry Christmas!</p>

  :date: "20021224"
  :title: <%=my('20021224', 'ruby 1.6.8 and 1.8.0-preview1')%>
  :author: matz
- :content: |
    <p>Matz's Slides at Ruby Conference 2002, OOPSLA2002, LL2 and O+F kansai(Japanese) are available.</p>
    <dl>
    <dt><a href="http://www.rubyconf.org/index.php">Ruby Conference 2002</a></dt>
    <dd>Slides: <a href="http://www.rubyist.net/~matz/slides/rc2002/">http://www.rubyist.net/~matz/slides/rc2002/</a></dd>
    <dt><a href="http://oopsla.acm.org/">OOPSLA 2002</a></dt>
    <dd>Slides: <a href="http://www.rubyist.net/~matz/slides/oopsla2002/">http://www.rubyist.net/~matz/slides/oopsla2002/</a></dd>
    <dt><a href="http://ll2.ai.mit.edu/">LL2</a></dt>
    <dd>Slides: <a href="http://www.rubyist.net/~matz/slides/ll2/">http://www.rubyist.net/~matz/slides/ll2/</a></dd>
    <dt><a href="http://of.good-day.net/">KANSAI OPENSOURCE+FREEWARE 2002</a></dt>
    <dd>Slides: <a href="http://www.rubyist.net/~matz/slides/of-kansai2002/">http://www.rubyist.net/~matz/slides/of-kansai2002/</a></dd>
    </dl>
    <p>Last item is in Japanese.  Compare it with LL2 slides in English to learn Japanese. :)  </p>

  :date: "20021205"
  :title: Matz's Slides at 4 conferences
  :author: NaHi
- :content: |
    <p>We  webmasters' team  of ruby-lang.org have  reformed our official
    site design, so that we can provide  natural contents navigation and
    just-in-time information about Ruby.</p>
    <p>Now we can offer a trial for a future official site.  Here we are:</p>
    <blockquote>
    <a href="http://dev.ruby-lang.org/en/">http://dev.ruby-lang.org/en/</a>
    </blockquote>
    <p>And here is Japanese site:</p>
    <blockquote>
    <a href="http://dev.ruby-lang.org/ja/">http://dev.ruby-lang.org/ja/</a>
    </blockquote>
    <p>Have a go and look at it.</p>
    <p>Our scheme is a double release with ruby 1.6.8;  the switchover of
    the site will be in the end of this year, if no critical problems
    are found.  If you find them, feel free to tell us via this list, or
    mail directly to the address below.</p>
    <p>Cheers,</p>
    <p align="right">-- ruby-lang.org webmaster team<br/>
    <a href="mailto:webmaster@ruby-lang.org">webmaster@ruby-lang.org</a>
    </p>

  :date: "20021216"
  :title: Toward ruby-lang.org renewal; trial website offered
  :author: ""
- :content: |
    <p> RAA is upgraded.</p>
    <p>Changes:</p>
    <ul>
    <li>URL was changed.  RAA is at
    <a href="http://raa.ruby-lang.org/">http://raa.ruby-lang.org/</a>
    now.  Former URL http://www.ruby-lang.org/en/raa.html
    is redirected to the new URL.</li>
    <li>Add new page "All" that lists all RAA entries by
    alphabetical order.</li>
    <li>Show number of projects in each major_category or
    minor category in listing view.  We have 753 projects
    now.  Is your stomach full?</li>
    <li>Add AND/OR search option.  RAA search is substring
    search, not a word search.</li>
    <li>Project's "name" field is restricted to match
    /\A[a-z0-9_-]{2,15}\z/ .
    <ul>
    <li>RAA users can refer a project with a simple name like
    "druby".  They don't have to remember the ID number or
    a long name like "druby - distributed ruby".</li>
    <li>Application owner must specify canonical name(s)
    of his/her project(s).</li>
    </ul>
    This field is a freezed (static, const) field.
    For each existing entries, I prepared a canonical name
    created from former name, Project UNIX Name in
    sourceforge or filename of its download item.  See
    <a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/58018">[ruby-talk:58018]</a> for your entry.
    Since I created canonical names automatically with
    a script[1], some owners would think that it isn't
    a suitable name for their project.
    So UNTIL THE END OF THIS YEAR(2002) owner can change
    this "name" field of his/her entry.  </li>
    <li>Add new field "short description".
    Owners can describe short(63 bytes or shorter)
    description here.
    At now, this field is filled with former "name" field.
    Feel free to change this field anytime.</li>
    <li>To add an application entry, you must type pass phrase
    twice.  Don't forget your pass phrase.</li>
    </ul>
    <p>[1] canonical name generation tool; http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/app/raa/tool/name_conv.rb
    </p>
    <pHave fun,<br/>
    RAA development team:<br/>
    NAKAMURA, Hiroshi aka NaHi and U.Nakamura aka usa.<br/>
    </p>

  :date: "20021207"
  :title: "<%=my('20021207', 'RAA.succ!.version #=> 2.1.0')%>"
  :author: NaHi
- :content: |
    <p>We webmasters decided to change the red only color scheme of this site following a recommendation in 
    <a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/59202">[ruby-talk:59202]</a>.</p>
    <p>
    You may see somewhat strange color scheme while our CSS
    development.
    Thank you for your kind corporation.</p>
    <p>And we also thank people who are discussing about color scheme
    on ruby-talk. </p>

  :date: "20021218"
  :title: <%=my('20021218', 'Color scheme of www.ruby-lang.org')%>
  :author: NaHi
- :content: |
    <p> Following RAA/2.1, RAA XML Interfaces are updated.</p>
    <ul>
    <li>SOAP &amp; XML-RPC interface
    You can get "short_description" from Project object.</li>
    <li>plain XML
    URLs are changed.
    <ul>
    <li><a href="http://raa.ruby-lang.org/raa-xml.xml">http://raa.ruby-lang.org/raa-xml.xml</a></li>
    <li><a href="http://raa.ruby-lang.org/raa-xml10.xml">http://raa.ruby-lang.org/raa-xml10.xml</a></li>
    </ul>
    Latter only includes 10 recently updated items.</li>
    <li>RSS/0.91
    URLs are changed.
    <ul>
    <li><a href="http://raa.ruby-lang.org/raa-rdf.xml">http://raa.ruby-lang.org/raa-rdf.xml</a></li>
    <li><a href="http://raa.ruby-lang.org/raa-rdf10.xml">http://raa.ruby-lang.org/raa-rdf10.xml</a></li>
    </ul>
    Is there anyone who can help us to serve RSS/1.0 file?</li>
    <li>YAML (not a XML!)
    <ul>
    <li><a href="http://raa.ruby-lang.org/raa-yaml.yml">http://raa.ruby-lang.org/raa-yaml.yml</a></li>
    <li><a href="http://raa.ruby-lang.org/raa-yaml10.yml">http://raa.ruby-lang.org/raa-yaml10.yml</a></li>
    </li>
    </ul>

  :date: "20021209"
  :title: RAA XML Interfaces are updated
  :author: NaHi
- :content: |
    Here on the Ruby Garden Wiki comes <a href="http://www.rubygarden.org/ruby?RubyIn2002">a page</a> to compile Ruby's year 2002 and plans on 2003. The deadline is January 9.
    RubyIn2002 <a href="http://www.rubygarden.org/ruby?RubyIn2002">http://www.rubygarden.org/ruby?RubyIn2002</a>
    This page supports a following plan: "The Year in Scripting Languages(Lua/Perl/Python/Ruby/Tcl)". The aim of that is to encourage these scripting language communities to collaborate with each other; its first step is to know neighbors, which will lead us to be able to share our efforts on scriptings. The chair person is Mitchell N. Charity.
    see also: <a href="http://www.ruby-talk.com/60604">[ruby-talk:60604]</a>, <a href="http://www.ruby-talk.com/60731">[ruby-talk:60731]</a>
    Final result can be seen at <a href="http://www.vendian.org/language_year/">http://www.vendian.org/language_year/</a>.

  :date: "20030107"
  :title: "<%=my('20030107', 'RubyIn2002: contents wanted')%>"
  :author: makitamuraSugHimsi
- :content: |
    RAA -- <a href="http://raa.ruby-lang.org/">Ruby Application Archive</a> -- has been updated. (see <a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/63170">[ruby-talk:63170]</a>)
    Changes:
    <ul>
    <li>Change URL: www.ruby-lang.org/raa -&gt; raa.ruby-lang.org
    Access to old URLs should be redirected.</li>
    <li>Add the page to show projects sort by chronologically.</li>
    <li>Introduce "What's updated" table at the top page.</li>
    <li>Add shortcut search box at top right of each page.</li>
    <li>Combine some sub-categories. <a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/62840">[ruby-talk:62840]</a></li>
    </ul>

  :date: "20030131"
  :title: "RAA.succ!.version #=> 2.3.0"
  :author: usa
- :content: |
    <p>(MNeumann announced the first European Ruby Conference
    at <a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/65418">[ruby-talk:65418]</a>.  Following is excerpted from the post.)
    </p>
    <blockquote>
    <p>The first European Ruby Conference will be held from 
    Saturday 21th to Sunday 22th June at the University of
    Karslruhe in Germany.
    </p>
    <p>Everyone instested in Ruby is welcome!
    </p>
    </blockquote>
    <p>(For more detail about the entrance fee, calling for speakers,
    mailing-lists, and so on, see <a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/65418">[ruby-talk:65418]</a>)</p>

  :date: "20030221"
  :title: First Europeen Ruby Conference
  :author: NaHi
- :content: |
    <p>(dblack posted an article
    'Happy Birthday, Ruby, and an announcement....' [ruby-talk:65632].
    Following is excerpted from the article.)</p>
    <blockquote>
    <p>Today, February 24, 2003, is Ruby's 10th birthday.  Happy Birthday, Ruby!  And congratz to Matz!</p>
    </blockquote>
    <p>dblack also annouces the new non-profit organization <a href="http://www.rubycentral.org">Ruby Central, Inc</a>
    and RubyConf 2003!. See <a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/65632">[ruby-talk:65632]</a>.

  :date: "20030224"
  :title: Happy Birthday, Ruby
  :author: NaHi
- :content: |
    Long time no minor version-up...
    Here is an initial official release of a stable version ((*ruby 1.8*)).
    The "download site":http://www.ruby-lang.org/download-1.8.0.rbx
    will lead you to the source code ruby-1.8.0.tar.gz.  Its MD5SUM is:
    582a65e52598a4a1e9fce523e16e67d6
    Binaries are going to be there.
    Some features are changed from previous stable version ruby 1.6.x;
    See "ftp://ftp.ruby-lang.org/pub/ruby/1.8/changes.1.8.0":ftp://ftp.ruby-lang.org/pub/ruby/1.8/changes.1.8.0.
    Thank you matz, and all committers, for all your trouble!

  :date: "20030804"
  :title: ruby-1.8.0 released!
  :author: sughimsi
- :content: |
    Today, Matz announced the availability of ruby 1.8.1 preview1 and, subsequently, "ruby 1.8.1 preview2":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.1-preview2.tar.gz ||  "rubyforge mirror":http://rubyforge.org/project/showfiles.php?group_id=30&release_id=152
    As always, we encourage Rubyists to download this preview release and put it through its paces.  Your testing, bug reports, and patches will lead to a stable ruby 1.8.1.

  :date: "20031030"
  :title: ruby 1.8.1 preview2
  :author: ""
- :content: |
    " Ruby Conference 2003": http://rubycentral.org/03/ will soon be held in November 14-16, 2003, on Austin, Texas U.S.A.
    " The registration is open": http://rubycentral.org/03/index.rb?dest=start_reg. Sign in!  Full registration will be open until Sunday, October 26.
    See also " [ruby-talk:83169]": http://www.ruby-talk.org/83169, and " [ruby-talk:84427]": http://www.ruby-talk.org/84427.

  :date: "20031001"
  :title: Ruby Conference 2003
  :author: sughimsi
- :content: |
    " Documentation for the Ruby 1.8 standard library": http://www.ruby-doc.org/stdlib/ is available.
    This is the HTML from the RDoc comments resulting from Gavin Sinclair's stdlib-doc project.

  :date: "20031123"
  :title: Ruby Standard Library Documentation
  :author: ""
- :content: |
    Ruby 1.8.1 preview3 is out.
    Go get "ruby 1.8.1 preview3":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.1-preview3.tar.gz ||
    "rubyforge mirror":http://rubyforge.org/project/showfiles.php?group_id=30.

  :date: "20031205"
  :title: ruby 1.8.1 preview3
  :author: NaHi
- :content: |
    In " [ruby-talk:88503]": http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/88503, David Alan Black announced the launch of the new official process for RCRs.  The new process is the result of matz's desire to further formalize the process, as expressed in his " RubyConf 2003": http://www.rubyconf.org " presentation": http://www.rubyist.net/%7Ematz/slides/rc2003.
    The new site for Ruby Change Requests is " rcrchive.net": http://rcrchive.net.
    Many thanks to " Dave Thomas": http://pragprog.com/pragdave, who facilitated the creation of the RCR process 3 years ago.

  :date: "20031219"
  :title: New Ruby Change Request (RCR) process
  :author: ""
- :content: |
    Mike Stok has written an excellent " recap": http://www.onlamp.com/pub/a/onlamp/2003/12/18/ruby_con.html of the 3rd International Ruby Conference, featured on the front page of O'Reilly's " ONLamp": http://www.onlamp.com site, entitled "Ruby's Present and Future".
    For additional post-conference information, see Jim Weirich's " site": http://onestepback.org/index.cgi/Tech/Conferences/RubyConf2003 or Ryan Davis's " Archive": http://www.zenspider.com/Languages/Ruby/RubyConf2003.html of the RubyConf presentations.

  :date: "20031220"
  :title: O'Reilly ONLamp Ruby article
  :author: ""
- :content: |
    Latest stable release ((*"ruby 1.8.1":http://www.ruby-lang.org/cgi-bin/download-1.8.1.mrb*)) is finally announced:
    This is mainly a bug fix release.
    Mirroring volunteers are welcome.
    The Md5 check sum is
    5d52c7d0e6a6eb6e3bc68d77e794898e  ruby-1.8.1.tar.gz
    Thank you matz and all committers.
    Happy Hacking Holidays.

  :date: "20031225"
  :title: ruby 1.8.1 is out
  :author: sughimsi
- :content: |
    We just started RSS feed in this site. Check it.
    http://www.ruby-lang.org/en/index.rdf

  :date: "20040117"
  :title: RSS feed started
  :author: sho
- :content: |
    For those interested in submitting a "Ruby Change Request":http://rcrchive.net, Jim Weirich has written an article on "How to write an RCR":http://onestepback.org/index.cgi/Tech/Ruby/WritingRcrs.rdoc.  Future RCR authors should consider it required reading.

  :date: "20040129"
  :title: How to write an RCR
  :author: ""
- :content: |
    Artima.com is running another 
    "segment":http://www.artima.com/intv/craft.html,
    (part four) of Bill Venners' interview with Matz.  Matz talks about becoming a better programmer through reading code, learning languages, focusing on fundamentals, being lazy, and considering interfaces.

  :date: "20040107"
  :title: Matz on Craftsmanship
  :author: ""
- :content: |
    The ruby-talk mailing has changed its posting policy. The list now requires one to be a member before posting a message.  This is a change from the previous "anyone may post" policy.
    If you've sent some recent list messages, but have not seen them on the list, check if you're using an appropriate "from" address, and look for any automated list admin messages coming back.

  :date: "20040215"
  :title: Ruby-talk Mailing Posting Policy Change
  :author: ""
- :content: |
    The March issue of "Linux Journal":http://www.linuxjournal.com/modules.php?op=modload&name=NS-lj-issues/issue119&file=index   has an article by James Britt on manipulating OpenOffice.org documents using Ruby.  
    Please note that the article has at least one error:  James, who, honestly, really does know better, incorrectly attributed REXML.  The creator/owner of REXML is Sean Russell.  

  :date: "20040216"
  :title: Ruby Article in Linux Journal
  :author: ""
- :content: |
    The "O'Reilly Open Source Convention (OSCON)":http://conferences.oreilly.com/os2004, taking place July 26-30 in Portland, OR, will include both a "Ruby track":http://conferences.oreillynet.com/pub/w/29/track_ruby.html and a series of "Ruby tutorials":http://conferences.oreillynet.com/pub/w/29/tutorial_ruby.html.   This is the first year the Conference has included a Ruby track. 

  :date: "20040412"
  :title: Ruby Track and Tutorials at OSCON
  :author: ""
- :content: |
    Pre-registration is open for the Fourth Annual International Ruby Conference, to be held in Reston, VA, USA, October 1-3 2004.  You can pre-register, and get more information about the conference, at "the RubyConf site":http://www.rubycentral.org/conference
    Even if you're new to Ruby, have a look -- the conference is designed to be as affordable as possible, and is a good place to learn more about Ruby and meet other Ruby programmers and enthusiasts.  

  :date: "20040523"
  :title: RubyConf 2004 pre-registration is open
  :author: ""
- :content: |
    On Fri May 28, we found that someone cracked helium.ruby-lang.org via CVS.
    "Read More...":/en/announce.txt

  :date: "20040529"
  :title: helium.ruby-lang.org was cracked
  :author: shugo
- :content: |
    Anonymous CVS service is restarted.
    The server accepts any password now:)
    "Read More...":/en/announce4.txt

  :date: "20040622"
  :title: Anonyous CVS service restart
  :author: shugo
- :content: |
    Sorry for our delayed report on restart operation on ruby-lang.org mailing list service. We should account current management of the lists orderly.
    "Read More...":/en/announce2.txt

  :date: "20040601"
  :title: Notice on ruby-lang.org mailing list service restart
  :author: shugo
- :content: |
    CVSweb service is restarted.
    "http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/":http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/

  :date: "20040624"
  :title: CVSweb service restart
  :author: shugo
- :content: |
    We have finished the validation on WWW/FTP contents, so we restarted WWW/FTP services.
    "Read More...":/en/announce3.txt

  :date: "20040615"
  :title: WWW/FTP service restart
  :author: shugo
- :content: |
    These checked modules are added to the Anonymous CVS repository.
    * app
    * lib(except soap4r,csv)
    * eruby
    * oniguruma
    * rough
    * rubicon
    * ruby-parser
    * shim
    * vms

  :date: "20040629"
  :title: modules added to the Anonymous CVS repository
  :author: shugo
- :content: |
    Registration for 
    "RubyConf 2004":http://www.rubycentral.org/conference is now open.  You can register
    "here":http://www.rubycentral.org/conference/register.html.
    The conference will be held in Chantilly, Virginia, USA, October 1-3.  Speakers will be announced soon; check the
    "conference website":http://www.rubycentral.org/conference for updates.  
    RubyConf 2004 is a production of "Ruby Central, Inc.":http://www.rubycentral.org

  :date: "20040731"
  :title: RubyConf 2004 registration now open
  :author: dblack
- :content: |
    "ruby 1.8.2 preview1":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview1.tar.gz
    was released.
    md5sum is 6cc070a768996f784fc7480d1c61bc85.
    You can download it at:
    * "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview1.tar.gz":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview1.tar.gz

  :date: "20040721"
  :title: ruby 1.8.2 preview1 released
  :author: shugo
- :content: |
    As already reported, helium.ruby-lang.org, which is one of the servers that provided various services relevant to Ruby evelopment, was cracked by an unauthorized user.  We, the ruby-lang.org administrators, are reporting our analysis of this intrusion and the countermeasures we've taken.
    "Read More...":/en/report.txt

  :date: "20040722"
  :title: Incident Analysis of the intrusion on helium.ruby-lang.org
  :author: shugo
- :content: |
    lib/soap4r, lib/csv, mod_ruby-old were added to the Anonymous CVS repository.
    Then, eruby was renamed to eruby-old.
    mod_ruby/eruby are developed on the Subversion repository now.

  :date: "20040705"
  :title: added lib/soap4r,lib/csv,mod_ruby-old to Anonymous CVS
  :author: shugo
- :content: |
    Anonymous CVS repository for csv(lib/csv) and soap4r(lib/soap4r)
    were once released to public at 2004-07-05 15:30:00 JST(2004-07-05
    06:30:00 UTC).  But I, the maintainer of these repository, found my
    checking process of CVS repository was not enough.  So I suspended the
    repositories again.  Users who checkout these repositories from
    2004-07-05 15:30:00 JST(2004-07-05 06:30:00 UTC) to 2004-07-06 16:30:00
    JST(2004-07-06 07:30:00 UTC) must check your CVS workspace.   I'm sorry
    for the trouble this error caused you.
    I'll report again after confirmation of these repositories.
    csv and soap libraries which are bundled to ruby's repository(/src/ruby)
    were confirmed that it is safe.

  :date: "20040706"
  :title: suspended lib/soap4r and lib/csv again
  :author: NaHi
- :content: |
    "ruby 1.8.2 preview2":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview2.tar.gz
    was released.
    md5sum is f40dae2bd20fd41d681197f1229f25e0.
    You can download it at:
    * "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview2.tar.gz":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview2.tar.gz

  :date: "20040730"
  :title: ruby 1.8.2 preview2 released
  :author: shugo
- :content: |
    Brad Cox, creator of Objective-C, will deliver the keynote address at this year's
    "International Ruby Conference":http://www.rubycentral.org/conference (RubyConf 2004).
    A leading expert on dynamic programming languages, Brad will speak on "The History and Design of Objective-C".  
    "Registration for RubyConf 2004":http://www.rubycentral.org/conference/register.html is still open.

  :date: "20040808"
  :title: Brad Cox to keynote RubyConf 2004
  :author: dblack
- :content: |
    RSYNC service is restarted.
    "rsync://ftp.ruby-lang.org/":rsync://ftp.ruby-lang.org/

  :date: "20040929"
  :title: RSYNC service restart
  :author: shugo
- :content: |
    "Korean translation of www.ruby-lang.org":http://cafe.naver.com/ruby/  is available. Thanks to Bryan Kang.

  :date: "20040918"
  :title: Korean translation of www.ruby-lang.org
  :author: shugo
- :content: |
    A link to "Ruby Forum":http://www.ruby-forum.org/bb was added to ((% my "20020105", "Community" %))
    Alexey Verkhovsky saids, `Ruby Forum is a newly created bulletin board for discussing Ruby. Unlike ruby-talk mailing list, it allows anonymous posting and implements more understandable interface for searching. Intended target audience of this forum is newcomers to Ruby that are not committed enough to subscribe to
    a 100+ posts/day mailing list.'

  :date: "20040922"
  :title: Ruby Forum
  :author: shugo
- :content: |
    Matz announced that "ruby 1.8.2 preview3":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview3.tar.gz was released ("ruby-core:03694":ruby-core:03694).
    md5sum is 64478c70a44a48af1a1c256a43e5dc61.
    You can download it at:
    * "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview3.tar.gz":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview3.tar.gz

  :date: "20041108"
  :title: 1.8.2 preview3 released
  :author: usa
- :content: |
    Matz announced that ruby 1.8.2 was released ("ruby-talk:124413":ruby-talk:124413 and "ruby-talk:124434":ruby-talk:124434).
    This is mainly a bug fix release. You can download it at:
    *"ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.2.tar.gz":ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.2.tar.gz
    md5sum is 8ffc79d96f336b80f2690a17601dea9b
    Merry Christmas!

  :date: "20041226"
  :title: Ruby 1.8.2 released!
  :author: maki
- :content: |
    "Programming Ruby" author Dave Thomas of the Pragmatic Programmers announced plans for a series of Ruby books from the Pragmatic Bookshelf (the Pragmatic Programmers' own imprint).  "The intent is to create a series of books with a deeply practical focus. We won't
    just document APIs. Instead, we want to show how to get _value_ from those APIs---how to solve real-world problems."
    See "the full announcement":http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/123137 for more information, including follow-up guidelines for potential authors.

  :date: "20041219"
  :title: Pragmatic Bookshelf planning a series of Ruby books
  :author: dblack
- :content: |
    Matz announced that "ruby 1.8.2 preview4":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview4.tar.gz was released ("ruby-core:04000":ruby-core:04000).
    md5sum is 2f53d4dc4b24e37799143645772aabd0.
    You can download it at:
    * "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview4.tar.gz":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.2-preview4.tar.gz

  :date: "20041222"
  :title: 1.8.2 preview4 released
  :author: usa
- :content: |
    "Ruby Central, Inc.":http://www.rubycentral.org has announced its first Ruby Codefest Grant Program.  This program is designed to provide support for local and regional groups working on development of Ruby libraries.  (See "full text of the announcement":http://www.rubycentral.org/grant/announce.html.)
    You can "apply for a grant":http://www.rubycentral.org/grant/application.html on behalf of your group.

  :date: "20041202"
  :title: Ruby Codefest Grant Program announced by Ruby Central, Inc.
  :author: dblack
- :content: |
    "Chinese translation of www.ruby-lang.org":http://rubycn.ce-lab.net/ is available now.
    Thanks, KOBAYASHI Toshihito.

  :date: "20041225"
  :title: Chinese translation of www.ruby-lang.org
  :author: shugo
- :content: |
    Tim Sutherland "announced":http://ruby-talk.org/cgi-bin/scat.rb/ruby/ruby-talk/131807 the latest publication of the "Ruby Weekly News":http://rubygarden.org/ruby/ruby?RubyNews/2005-02-14.  The Ruby Weekly News is a weekly summary of the "ruby-talk":http://www.ruby-talk.org mailing list.  Tim recently resurrected it after an extended hiatus.
    The Ruby Weekly News is a great way to stay in touch with what's happening in the world of ruby-talk as its volume continues to grow.  Many thanks to Tim for this valuable resource!

  :date: "20050220"
  :title: Ruby Weekly News
  :author: chad
- :content: |
    Ruby Central "announced":http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/133197 the the recipients of its first "CodeFest Grant Program":http://www.rubycentral.org/grant/announce.html.
    Five projects were awarded funding to support regional coding sessions, whose aim are to build working Ruby code to fill a void in the landscape of available Ruby libraries.
    Congratulations to the recipients!   

  :date: "20050311"
  :title: RubyCentral CodeFest Grants Announced
  :author: chad
- :content: |
    Preregistration for the upcoming Fifth Annual International Ruby Conference (RubyConf 2005) is now open.  RubyConf 2005 will be held in San Diego, CA, October 14-16.
    You can preregister 
    "here":http://www.rubycentral.org/conference/prereg/.  The full announcement is "here":
    http://www.ruby-talk.org/cgi-bin/scat.rb/ruby/ruby-talk/134660.

  :date: "20050323"
  :title: RubyConf 2005 Preregistration now open
  :author: ""
- :content: |
    Anonymous CVS Service was restarted.
    Thank you.

  :date: "20050427"
  :title: Anonymous CVS Service Restart
  :author: shugo
- :content: |
    We stopped the anonymous CVS service because of "Security Update of CVS":https://ccvs.cvshome.org/servlets/NewsItemView?newsItemID=141.
    The service will be restarted after Debian package update.

  :date: "20050419"
  :title: Anonymous CVS Service Stopped
  :author: shugo
- :content: |
    We'll be performing server maintenance on Thu Apr 14 03:00:00 UTC 2005. It may be down briefly.

  :date: "20050414"
  :title: Server Maintenance
  :author: ""
- :content: |
    We'll upgrade this host to Debian GNU/Linux 3.1 (sarge)
    on Wed Jun 29 05:00:00 UTC 2005.
    Services will be stopped for a while.
    Successfully DONE. Thank you.

  :date: "20050622"
  :title: Upgrade to Debian GNU/Linux 3.1
  :author: shugo
- :content: |
    On Fri Jun 17 2005, a vulnerability of XMLRPC.iPIMethods was reported
    in [ruby-core:05237].
    Remote attackers can execute arbitrary commands by this vulnerability.
    h1. Affected Programs
    Programs providing XML-RPC services by XMLRPC.iPIMethods are affected.
    h1. Fix
    This vulnerability was already fixed in both the CVS HEAD and the ruby_1_8
    branch.
    Please apply this patch for ruby-1.8.2.
    * "ruby-1.8.2-xmlrpc-ipimethods-fix.diff":/patches/ruby-1.8.2-xmlrpc-ipimethods-fix.diff

  :date: "20050701"
  :title: XMLRPC.iPIMethods Vulnerability
  :author: shugo
- :content: |
    Created "security@ruby-lang.org":mailto:security@ruby-lang.org .
    If you have found vulnerabilities in Ruby, please report to this address.
    security@ruby-lang.org is a private ML, and anyone can post to it without subscription.

  :date: "20050702"
  :title: security@ruby-lang.org
  :author: shugo
- :content: |
    David Black "announced":http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/154337 on ruby-talk that there are now  136 registrants, from 12 countries, for RubyConf 2005.  If you still have not registered, do it now.  
    Full registration  (i.e., full meal plans) ends in two weeks.  Non-full may continue past that, but not forever.  
    Go to the "RubyConf":http://www.rubyconf.org site for complete registration details.

  :date: "20050831"
  :title: "RubyConf 2005 Registration: Time is running out"
  :author: james
- :content: |
    David A. Black recently reported on ruby-talk that over 100 people have registered for "RubyConf 2005":http://www.rubyconf.org/, to be held this coming October 14-16 in San Diego.
    If you haven't yet registered, now is the time!

  :date: "20050820"
  :title: RubyConf 2005 Registration Tops 100
  :author: ""
- :content: |
    Ruby 1.8.3 has been released.  The source is
    "here":ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.3.tar.gz,
    and the md5sum is 63d6c2bddd6af86664e338b31f3189a6.

  :date: "20050921"
  :title: Ruby 1.8.3 released
  :author: dblack
- :content: |
    Registration for RubyConf 2005 is CLOSING soon.
    The schedule is as follows:
    * Friday, September 16: last day for full registration (meals included)
    * Friday, September 23: last day for events-only registration (no meals)
    So, all you stragglers, get over to the "RubyConf site":http://www.rubycentral.org/conference/register

  :date: "20050907"
  :title: Registration for RubyConf 2005 is CLOSING soon.
  :author: james
- :content: |
    "EuRuKo 2005":http://www.approximity.com/cgi-bin/europeRuby/tiki.cgi?c=v&amp;p=Euruko05, the European Ruby Conference, will be in Munich, Germany, October 15 and 16, 2005.  
    If you have any means whatsoever to attend, go.  It is still fairly small, and the intimate feeling of the conference is something special.
    You can see the current agenda "here":http://www.approximity.com/cgi-bin/europeRuby/tiki.cgi?c=v&amp;p=Euruko05AgendaDetail, but last year there were assorted spontaneous talks and discussions as well and it will likely be the same this year. 

  :date: "20051010"
  :title: EuRuKo 2005
  :author: james
- :content: |
    The newest on-line resource for serious Ruby information has gone live.  
    "Ruby Code & Style":http://www.artima.com/rubycs/index.html, an on-line magazine from "Artima":http://www.artima.com, has just published issue #1.
    Check out the names on the advisory board. It's a Who's Who of everybody who's anybody in the Ruby world.
    The premiere issue has three outstanding articles:
    First up, Jack Herrington, author of Code Generation in Action (Manning, 2002) and Podcasting Hacks (O'Reilly, 2005), has written "Modular Architectures with Ruby":http://www.artima.com/rubycs/articles/modular_apis_with_ruby.html
    Next, Austin Ziegler gives us "Creating Printable Documents with Ruby":http://www.artima.com/rubycs/articles/pdf_writer.html
    And there's a reprint of Ara Howard's article, "Linux Clustering with Ruby Queue: Small is Beautiful":http://www.artima.com/rubycs/articles/rubyqueue.html, which first appeared in Linux Journal but deserves repeat attention
    A big thanks to the advisory board, and especial to Bill Venners for starting this whole thing.

  :date: "20051011"
  :title: New Ruby Web Magazine Goes Live
  :author: james
- :content: |
    The Ruby versions listed below have a vulnerability that allows an arbitrary code to run bypassing the safe level check.
    Date published: 2005-10-02
    Versions affected:
    Stable releases(1.8.x) - Versions 1.8.2 and earlier
    (fixed on Version 1.8.3)
    Old releases(1.6.x) - Versions 1.6.8 and earlier
    Development versions(1.9.0) - Versions 2005-09-01 and earlier
    (fixed on Version 2005-09-02)
    h1. Solution:
    Users of stable releases (1.8.x) and development versions (1.9.0) should
    update Ruby to the latest versions listed above.
    Users of old releases (1.6.x) should update to the stable releases (1.8.x)
    or download the latest snapshot for 1.6.x from the URL below, build, and
    install.
    "ftp://ftp.ruby-lang.org/pub/ruby/snapshot-1.6.tar.gz":ftp://ftp.ruby-lang.org/pub/ruby/snapshot-1.6.tar.gz
    A patch from ruby-1.6.8.tar.gz is also provided at the following location:
    "ftp://ftp.ruby-lang.org/pub/ruby/1.6/1.6.8-patch1.gz":ftp://ftp.ruby-lang.org/pub/ruby/1.6/1.6.8-patch1.gz
    md5sum: 7a97381d61576e68aec94d60bc4cbbab
    A patch from ruby-1.8.2.tar.gz is also provided at the following location:
    "ftp://ftp.ruby-lang.org/pub/ruby/1.8/1.8.2-patch1.gz":ftp://ftp.ruby-lang.org/pub/ruby/1.8/1.8.2-patch1.gz
    md5sum: 4f32bae4546421a20a9211253da103d3
    h1. Description:
    The Object Oriented Scripting Language Ruby supports safely executing an
    untrusted code with two mechanisms: safe level and taint flag on objects.
    A vulnerability has been found that allows bypassing these mechanisms.
    By using the vulnerability, arbitrary code can be executed beyond the
    restrictions specified in each safe level. Therefore, Ruby has to be
    updated on all systems that use safe level to execute untrusted code.
    h1. Reference:
    JVN#62914675 "http://jvn.jp/jp/JVN%2362914675/index.html":http://jvn.jp/jp/JVN%2362914675/index.html
    (in Japanese)
    h1. Acknowledgment:
    We thank Dr. Yutaka Oiwa, Research Center for Information Security,
    National Institute of Advanced Industrial Science and Technology, who
    found the vulnerability that allows bypassing safe level.

  :date: "20051003"
  :title: Ruby vulnerability in the safe level settings
  :author: matz
- :content: |
    Ruby 1.8.4 has been released.
    The source is "ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.4.tar.gz":ftp://ftp.ruby-lang.org/pub/ruby/ruby-1.8.4.tar.gz, the md5sum is bd8c2e593e1fa4b01fd98eaf016329bb, and filesize is 4,312,965 bytes.

  :date: "20051224"
  :title: Ruby 1.8.4 released!
  :author: maki
- :content: |
    Ruby 1.8.4 preview 2 has been released.  You can download the source
    "here":ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.4-preview2.tar.gz.
    The md5 sum is: e5a48054fb34f09da17e8e8f04b8c706

  :date: "20051214"
  :title: Ruby 1.8.4 preview 2 released
  :author: dblack
- :content: |
    This coming spring and summer are shaping up to be a real "conference
    alley" for Rubyists.  (And RubyConf 2006 hasn't even been announced yet!)  Upcoming events of interest include:
    "Canada on Rails":http://www.canadaonrails.org, April 13-14 
    "Silicon Valley Ruby 
    Conference":http://www.sdforum.org/rubyconference, April
    22-23, co-produced by "SDForum":http:/www.sdforum.org
    and "Ruby Central, Inc.":http://www.rubycentral.org
    the first official "International Rails 
    Conference":http://www.railsconf.org, June 22-25, produced by
    "Ruby Central, Inc.":http://www.rubycentral.org
    the "Ruby track":http://conferences.oreillynet.com/cs/os2006/create/e_sess/ at "OSCON":http://conferences.oreillynet.com/os2006/, July 24-28 (call for papers closing soon!)
    Check specific events for information about submitting talk proposals
    and/or registering to attend.

  :date: "20060209"
  :title: Conference season is here
  :author: dblack
- :content: |
    Student Rubyists will be able to participate in the
    "Google Summer of Code":http://code.google.com/soc/
    this summer, with 
    "Ruby Central, Inc.":http://www.rubycentral.orgRuby Central, Inc.
    as mentoring organization.  See the
    "Summer of Code page":http://www.rubycentral.org/soc2006
    at Ruby Central.

  :date: "20060419"
  :title: Ruby in Google Summer of Code
  :author: dblack

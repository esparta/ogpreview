# OpenGraph Previewer

This small application demonstrate some parts of the web development
done by Espartaco Palma.

See instructions to execute this app in [Executing OgPreview section](#executing-ogpreview)

Goals
---

The goal of the application is to obtain the images offered by a given URL, using
the OpenGraph tags when available. This app exposes an API that can be used
as a Microservice serving the resolution of "Thumbnails" of websites, and also
provides a standalone app for review.

![OgPreview in action](ogpreview_demo.gif)

The process for the Previewer application includes:

- Validate input
- Process the request
- Execute callbacks for polling

## Validate input

The web is a weird and wild place to be, that's why we should validate any user
input. For minimal aspect we can roll out our own validation nesting
if while receiving the parameters, but here I'm using a gem specifically created
for this purpose: [Dry::Validation][dry_validation], with this we save a lot
of boilerplate and even be able to control some business rules:

I'm applying minimal rules for the user input but it can be expanded:

- Minimal input should be 4 chars long
- Maximal input should be less than 300 chars long
- The input should have a valid schema http or https

This small piece will return errors by default, which we can just send back
to the caller if needed at controller level.

We don't process unless the parameters complains with the rules.

## Processing the request

This step is also break on small testable pieces:

- Verify reachability
- Persisting the requested URL input
- Obtaining the Opengraph
- Persisting the images


### Verify reachability

Before trying to parse I'm issuing HEAD request to the already validated input.
The gem HTTP is using here instead of the Net::HTTP library included in ruby's
standard library because their flexibility and security.

It can be configured to have timeouts, which can be used in the future.

### Persisting the requested URL input

We will persist the requested URLs, this records will be used in the future
to update the status of them, initially the status will be `enqueued`, meaning
we receive the petition, and will be processing it soon.

If there's some problem persisting the data in the database, their
status will be changed to 'error' and log the problem.

### Obtaining the Opengraph

The URL was already validated, we are sure we can reach the URL and persisted
it as the reference. So we will try to obtain the OpenGraph's metadata. At 
this point the status will be changed to `parsing`.

I'm using the gem called [OpenGrahp Parser][opengraph_parser], I've used this
gem in the past instead of the recommended on Facebook's OpenGrah website,
because it doesn't have a dependency with a old and pinned version of
nokogirigirl gem that has not been patched a long time ago, having a huge
security problem.

If there's any issue getting the metadata, the status of the request is changed
to `errorr` and log the problem.

### Persisting the images

Once obtained the metadata we will proceed to persist any images declared by
the metadata.

In this step the status is changed to `downloading`. I'm using the gem
called [Down][down_gem] to download the image from specified on the metadata.
The rationale goes about how flexible this gem is. With Down we can configure
multiple performance and security aspects such as:

- Timeouts
- Size of the file to download
- Chunk reading

Per every image downloaded we will be attaching them to the database using the
Rails own engine [ActiveStorage][active_storage], which can also be configured
to perform other task as resizing (which I'm not using right now). ActiveStorage
can also be configure to use many different backend as Amazon S3, Azure, GCP at
this time.

Once we download all the images, the status change to `ready`.

Creating Step process and Modules
===

In order process the request I'm using a gem called [Dry::Monads][dry_monads],
this give us the ability to create modules that follow the Monads principles
of computing, where, once you execute a given function you either return a
Success or Failure. For example:

```ruby
d = Downloader.get('http://example.com/image.jpg')
if d.success?
  # continue working
else
  # Fallback
end
```

The above looks simply enough to just use a `nil` checking, or use exceptions.
But when combined with `Do Notation`, the power of the Monads can be reached.
Instead of nested conditions and try..catch blocks, we just do small Monads and
chain them in notations that looks similar to what functional programming has:

```
with(url)
 |> create_tracking
 |> verify_website
 |> parse_opengraph
 |> extract_images
 |> persist_as_done
```

No `if` needed nor `nil` checks, not need for catching exceptions. This approach
is also called the [Railway Oriented Programming][railway_programming]. The
process is done in the class `Transaction`:

```ruby
  def call(uri, user_id, job_id)
    url = yield create_url(uri, user_id, job_id)
    parsed = yield opengraph(url)
    images = yield extract_images(parsed)
    attach_images(images)
  end
```

The module will be trying to do their job, and continue if and only if the
previous step was successful execute (returned a Success object), otherwise
(it return a Failure), halting the execution.

At the end, the whole process is having no business logic but this:

```ruby
  transaction = Transaction.call(...)
  Rails.logger.error(transaction.failure) if transaction.failure?
```

The above can be read as "Do the Transaction, if you were not able, just log the
error".

The benefit is a process better, focused, and composable enough to operate by their
own, and highly testable on isolation. When using the mixing the job is done
and the caller, in this case the ActiveJob, has less knowledge of what is
happening and how.

Callback for polling
===

When the user request the URL for Preview we immediately respond with an
acknowledge token, preventing any blocking and letting the caller (in this case
the standalone web page) to ask for this specific token on a polling basis.
The website is configured to asynchronously request for update of the given token,
and take decision based on the response and statuses.

If any other client request the same website, we will try to verify if we have
it on our records and issue the same token, letting them call back as if this
was the same user that first requested. This may add some round trips but also
simplify the logic on controller level.

The poller will be doing a GET request to /status using the acknowledge parameter.
Since the processing is also done asynchronously, we will always have an answer
for any given user. As mention early, we will be answer with one of these
statuses:

- enqueued
- parsing
- downloading
- ready
- error

Once the given URL is process, the API also provides a series of URLs when
ready:

```json
{ "status": "ready",
  images: ["http://localhost:3000/path_image1",
           "http://localhost:3000/path_image2",
           "http://localhost:3000/path_imagen"
  ]
}
```

Since the client will be using the images from our application, the app role
is now a proxy between the given images on the requested website and the
client.

Next Steps
===

If this were a functional product, it can be easily transformed to a two-way
communication approach using websocket. Rails has ActiveChannel available and
can be done a more real-time notification.

Executing OgPreview
===

How to run on local machine
---

You need [nodejs][nodejs] and [yarn][yarn] installed:

Run `yarn && bundle && rails s` to make the magic happen

How to run with Docker
---

You need docker and docker-compose installed

Provisioning
---

Run the following commands to prepare your Docker dev env:

```bash
docker-compose build
docker-compose run runner yarn install
docker-compose run runner ./bin/setup
```

The above command builds the Docker image, installs Ruby and NodeJS dependencies,
creates database, run migrations and seeds.

Commands
---

You can run the Rails up using the following command:

```bash
docker-compose up rails
```

If you want to run Webpack Dev server as well:

```bash
docker-compose up rails webpacker
```

Once your Rails server is running, just point the local URL:
http://localhost:3000

Tests
===

For local environment, use the usual command:

```bash
bundle exec rspec
# or
# bundle exec rake
```

You can execute the test on Docker, using this command:

```bash
docker-compose run runner rspec
# or
# docker-compose run runner rake
```


[railway_programming]: https://fsharpforfunandprofit.com/rop/
[dry_monads]: https://dry-rb.org/gems/dry-monads
[dry_validation]: https://dry-rb.org/gems/dry-validation/
[opengraph_parser]: https://rubygems.org/gems/opengraph_parser
[down_gem]: https://rubygems.org/gems/down
[active_storage]: https://edgeguides.rubyonrails.org/active_storage_overview.html
[nodejs]: https://nodejs.org/en/download/
[yarn]: https://yarnpkg.com/lang/en/docs/install

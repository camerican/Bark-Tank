


## Carrierwave

Carrierwave is an image-uploading library better suited to non-rails projects than Papperclip.  To set Carrierwave up 



### Adding remote files to seedfile

We can upload remote images in carrierwave to our seeds.rb file by using the syntax:

```
remote_[column_name]_url
```

Since we've called the user image 'photo', the syntax for the key will be:

```
remove_photo_url
```

Reference: [[Carrierwave Wiki](https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Upload-remote-image-urls-to-your-seedfile)] 

## Regex for data insertion

```regex
\('([^']+)', '([^']+)', '([^']+)', '([^']+)' \),?;?\n?
{\n    name_first: '$1',\n    name_last: '$2',\n    slack_name: '$3',\n    remote_photo_url: '$4'\n  },
```


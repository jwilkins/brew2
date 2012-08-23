home 'http://packages.debian.org/source/stable/sl'

source 'http://mirrors.kernel.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz',
       'http://ftp.us.debian.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz',
       'd0d997b964bb3478f7f4968eee13c698'

fails_with :clang, 318

install do
  system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
  mv "sl", :bin
  mv "sl.1", :man1
end

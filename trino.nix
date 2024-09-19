{ lib
, stdenv
, fetchurl
, makeWrapper
, jre
}:

stdenv.mkDerivation rec {
  pname = "trino";
  version = "415";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/io/trino/trino-server/${version}/trino-server-${version}.tar.gz";
    sha256 = "sha256-28h2HQ2jL6+l87/Va/OiaC8MxGwyQH8rXihfzRUT21A=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/trino
    cp -R * $out/share/trino

    mkdir -p $out/bin
    classpath=$(find $out/share/trino/lib -type f -name '*.jar' | tr '\n' ':')
    makeWrapper ${jre}/bin/java $out/bin/trino \
      --add-flags "-server" \
      --add-flags "-Xmx16G" \
      --add-flags "-XX:+UseG1GC" \
      --add-flags "-XX:+HeapDumpOnOutOfMemoryError" \
      --add-flags "-XX:+ExitOnOutOfMemoryError" \
      --add-flags "-Dlog4j.configurationFile=$out/share/trino/etc/log.properties" \
      --add-flags "-cp $classpath" \
      --add-flags "io.trino.server.TrinoServer"
  '';

  meta = with lib; {
    description = "Distributed SQL query engine for big data";
    homepage = "https://trino.io/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ]; # Add maintainers if known
  };
}
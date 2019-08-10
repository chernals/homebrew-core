class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "http://geant4-data.web.cern.ch/geant4-data/releases/source/geant4.10.05.p01.tar.gz"
  version "10.5.1"
  sha256 "f4a292220500fad17e0167ce3153e96e3410ecbe96284e572dc707f63523bdff"

  bottle do
    cellar :any
    sha256 "268255d7e0af6a6dfb1305eed9f3a838a44fe9ef67ef465b510a60893de8f571" => :mojave
    sha256 "7ed35e045f2ea368fce0ee929406187b230ea608ec2328e539b82c25e878f09b" => :high_sierra
    sha256 "c3e542d8f1ff4561437e31b8aae44fe00e922d613bfaaa56611e7392f897c22c" => :sierra
  end

  option "with-gdml", "Build Geant with GDML support"
  option "with-multithreaded", "Build Geant with multithreading support"
  option "with-usolids", "Use USolids (experimental)"
  option "with-qt", "Build Geant with QT visualization support"
  option "without-examples", "Do not build Geant4 examples"
  option "with-system-clhep", "Use system CLHEP"
  option "with-opengl-x11", "Build the X11 OpenGL visualization driver"
  option "with-raytracer-x11", "Build RayTracer visualization driver with X11 support"

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :optional
  depends_on "xerces-c" if build.with? "gdml"

  resource "G4NDL" do
    url "https://cern.ch/geant4-data/datasets/G4NDL.4.5.tar.gz"
    sha256 "cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e"
  end

  resource "G4EMLOW" do
    url "https://cern.ch/geant4-data/datasets/G4EMLOW.7.7.tar.gz"
    sha256 "16dec6adda6477a97424d749688d73e9bd7d0b84d0137a67cf341f1960984663"
  end

  resource "PhotonEvaporation" do
    url "https://cern.ch/geant4-data/datasets/G4PhotonEvaporation.5.3.tar.gz"
    sha256 "d47ababc8cbe548065ef644e9bd88266869e75e2f9e577ebc36bc55bf7a92ec8"
  end

  resource "RadioactiveDecay" do
    url "https://cern.ch/geant4-data/datasets/G4RadioactiveDecay.5.3.tar.gz"
    sha256 "5c8992ac57ae56e66b064d3f5cdfe7c2fee76567520ad34a625bfb187119f8c1"
  end

  resource "G4SAIDDATA" do
    url "https://cern.ch/geant4-data/datasets/G4SAIDDATA.2.0.tar.gz"
    sha256 "1d26a8e79baa71e44d5759b9f55a67e8b7ede31751316a9e9037d80090c72e91"
  end

  resource "G4PARTICLEXS" do
    url "https://cern.ch/geant4-data/datasets/G4PARTICLEXS.1.1.tar.gz"
    sha256 "100a11c9ed961152acfadcc9b583a9f649dda4e48ab314fcd4f333412ade9d62"
  end

  resource "G4ABLA" do
    url "https://cern.ch/geant4-data/datasets/G4ABLA.3.1.tar.gz"
    sha256 "7698b052b58bf1b9886beacdbd6af607adc1e099fc730ab6b21cf7f090c027ed"
  end

  resource "G4INCL" do
    url "https://cern.ch/geant4-data/datasets/G4INCL.1.0.tar.gz"
    sha256 "716161821ae9f3d0565fbf3c2cf34f4e02e3e519eb419a82236eef22c2c4367d"
  end

  resource "G4PII" do
    url "https://cern.ch/geant4-data/datasets/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "G4ENSDFSTATE" do
    url "https://cern.ch/geant4-data/datasets/G4ENSDFSTATE.2.2.tar.gz"
    sha256 "dd7e27ef62070734a4a709601f5b3bada6641b111eb7069344e4f99a01d6e0a6"
  end

  resource "RealSurface" do
    url "https://cern.ch/geant4-data/datasets/G4RealSurface.2.1.1.tar.gz"
    sha256 "90481ff97a7c3fa792b7a2a21c9ed80a40e6be386e581a39950c844b2dd06f50"
  end

  def install
    mkdir "geant-build" do
    args = %w[
      ../
    ]
    args << "-DGEANT4_USE_OPENGL_X11=ON" if build.with? "opengl-x11"
    args << "-DGEANT4_USE_RAYTRACER_X11=ON" if build.with? "raytracer-x11"
    args << "-DGEANT4_USE_XM=OFF"
    args << "-DGEANT4_INSTALL_DATA=ON"
    args << "-DGEANT4_BUILD_EXAMPLE=OFF" if build.without? "example"
    args << "-DGEANT4_USE_QT=ON" if build.with? "qt"
    #args << "-DQT_QMAKE_EXECUTABLE=/usr/local/opt/qt/bin/qmake" if OS.mac? and build.with? "qt"
    args << "-DGEANT4_USE_G3TOG4=ON" if build.with? "g3tog4"
    args << "-DGEANT4_USE_GDML=ON" if build.with? "gdml"
    args << "-DGEANT4_USE_USOLIDS=ON" if build.with? "usolids"
    args << "-DGEANT4_BUILD_MULTITHREADED=ON" if build.with? "multithreaded"
    args << "-DGEANT4_BUILD_MULTITHREADED=OFF" if build.without? "multithreaded"
    args << "-DGEANT4_USE_SYSTEM_CLHEP=ON" if build.with? "system-clhep"
    args.concat(std_cmake_args)
    system "cmake", *args
    system "make", "-j16", "install"
  end

    resources.each do |r|
      (share/"Geant4-#{version}/data/#{r.name}#{r.version}").install r
    end
  end

  def caveats; <<~EOS
    Because Geant4 expects a set of environment variables for
    datafiles, you should source:
      . #{HOMEBREW_PREFIX}/bin/geant4.sh (or .csh)
    If using zsh use this variant:
      pushd /usr/local/bin >/dev/null; . ./geant4.sh; popd >/dev/null
    before running an application built with Geant4.
  EOS
  end

  test do
    system "cmake", share/"Geant4-#{version}/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<~EOS
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    assert_match "Number of events processed : 1000",
                 shell_output("/bin/bash test.sh")
  end
end

defmodule Task1bNumberDetection do
  alias Evision, as: OpenCV

  # This function is used to resize a given image
  def resize(image, width, height) do
    OpenCV.resize!(image, [_width = width, _height = height])
  end

  # The main function which reads the image as graysacale using "get_gray_img_ref" function
  # while cropping it as per sepcified dimensions using "crop" function
  # and displays it using "show" function
  def drawContour(img) do
    {contours, _} =
      OpenCV.findContours!(img, OpenCV.cv_RETR_TREE(), OpenCV.cv_CHAIN_APPROX_SIMPLE())

    red = Enum.filter(contours, fn i -> elem(i.shape, 0) != 4 end)
    red
  end

  def int(text) when text == :error do
    "na"
  end

  def int(text) do
    "#{elem(text, 0)}"
  end

  def read() do
    a = File.ls!("roi_container")
    a = Enum.sort(a)
    len = trunc(:math.sqrt(length(a)))
    # IO.inspect(len)
    # for i <- a do
    #   text = TesseractOcr.read("roi_container/#{i}", %{psm: 13})
    #   IO.inspect(Integer.parse(text))
    # end
    text =
      Enum.reduce(a, [], fn i, acc ->
        acc ++ [int(Integer.parse(TesseractOcr.read("roi_container/#{i}", %{psm: 13})))]
      end)

    # text = Enum.chunk_every(text, len)
    text = Enum.chunk_every(text, len)
    # IO.inspect(text)
    text
    # text
  end

  def contour_helper(img, c) do
    {x, y, w, h} = OpenCV.boundingRect!(c)
    tens = OpenCV.Nx.to_nx!(img, Nx.BinaryBackend)
    # tens = Image.crop
    slice = Nx.slice(tens, [y, x], [h, w])
    # IO.inspect([x: y..y+h, y: x..x+w])
    # tens = Nx.slice(tens, [Nx.tensor(y), Nx.tensor(x)], [h, w])
    mat = OpenCV.Nx.to_mat!(slice)
    roi = mat
    # show roi
    # roi = OpenCV.cvtColor!(roi, OpenCV.cv_COLOR_BGR2GRAY)
    # roi = OpenCV.medianBlur!(roi, 1)
    # blur = OpenCV.medianBlur!(roi, 5)
    # blur = elem(OpenCV.threshold!(blur,0,255,OpenCV.cv_THRESH_BINARY_INV), 1)
    # show(blur)
    roi
  end

  def roi_helper(all_images, i, _max_size) when length(all_images) == i do
    []
  end

  def roi_helper(all_images, i, max_size) do
    curr_img = Enum.at(all_images, i)
    # IO.inspect(curr_img)
    shape = curr_img.shape

    if elem(shape, 0) > max_size do
      OpenCV.imwrite!("roi_container/ROI_#{i}.png", curr_img)
    end

    roi_helper(all_images, i + 1, max_size)
  end

  @doc """
  #Function name:
        identifyCellNumbers
  #Inputs:
        image  : Image path with name for which numbers are to be detected
  #Output:
        Matrix containing the numbers detected
  #Details:
        Function that takes single image as an argument and provides the matrix of detected numbers
  #Example call:

      iex(1)> Task1bNumberDetection.identifyCellNumbers("images/grid_1.png")
      [["22", "na", "na"], ["na", "na", "16"], ["na", "25", "na"]]
  """
  def identifyCellNumbers(path) do
    File.mkdir!("roi_container")
    # path = "images/grid_#{img_number}.png"
    grayImgRef = OpenCV.imread!(path, flags: OpenCV.cv_IMREAD_GRAYSCALE())
    gray = resize(grayImgRef, 300, 300)
    # show gray
    blur = OpenCV.medianBlur!(gray, 1)
    # show blur
    # IO.inspect(sharpen_kernel)
    # sharpen = OpenCV.filter2D!(blur, -1, sharpen_kernel)
    # show sharpen
    thresh =
      elem(
        OpenCV.threshold!(blur, 0, 255, OpenCV.cv_THRESH_BINARY_INV() + OpenCV.cv_THRESH_OTSU()),
        1
      )

    # show thresh
    # thresh
    # drawContour(thresh)
    cnts = drawContour(thresh)
    # cnts
    # contour_helper(gray, Enum.at(cnts, 0))
    all_images = Enum.reduce(cnts, [], fn c, acc -> acc ++ [contour_helper(gray, c)] end)

    sizes = Enum.reduce(all_images, [], fn i, acc -> acc ++ [i.shape] end)

    max_size = elem(Enum.max(sizes), 0) - 5
    all_images = Enum.reverse(all_images)

    roi_helper(all_images, 0, max_size)
    # max_size
    # # empty()
    a = read()
    File.rm_rf!("roi_container")
    a
  end


  @doc """
  #Function name:
         identifyCellNumbersWithLocations
  #Inputs:
         matrix  : matrix containing the detected numbers
  #Output:
         List containing tuple of detected number and it's location in the grid
  #Details:
         Function that takes matrix generated as an argument and provides list of tuple
  #Example call:

        iex(1)> matrix = Task1bNumberDetection.identifyCellNumbers("images/grid_1.png")
        [["22", "na", "na"], ["na", "na", "16"], ["na", "25", "na"]]
        iex(2)> Task1bNumberDetection.identifyCellNumbersWithLocations(matrix)
        [{"22", 1}, {"16", 6}, {"25", 8}]
  """

  def index_helper(list, acc, _idx) when list == [] do
    acc
  end

  def index_helper([head | tail], acc, idx) when head == "na" do
    index_helper(tail, acc, idx + 1)
  end

  def index_helper([head | tail], acc, idx) when head != "na" do
    acc = acc ++ [{head, idx}]

    index_helper(tail, acc, idx + 1)
  end

  def identifyCellNumbersWithLocations(matrix) do
    list = Enum.flat_map(matrix, fn l -> l end)
    index = index_helper(list, [], 1)
    index
  end

  @doc """
  #Function name:
         driver
  #Inputs:
         path  : The path where all the provided images are present
  #Output:
         A final output with image name as well as the detected number and it's location in gird
  #Details:
         Driver functional which detects numbers from mutiple images provided
  #Note:
         DO NOT EDIT THIS FUNCTION
  #Example call:

      iex(1)> Task1bNumberDetection.driver("images/")
      [
        {"grid_1.png", [{"22", 1}, {"16", 6}, {"25", 8}]},
        {"grid_2.png", [{"13", 3}, {"27", 5}, {"20", 7}]},
        {"grid_3.png", [{"17", 3}, {"20", 4}, {"11", 5}, {"15", 9}]},
        {"grid_4.png", []},
        {"grid_5.png", [{"13", 1}, {"19", 2}, {"17", 3}, {"20", 4}, {"16", 5}, {"11", 6}, {"24", 7}, {"15", 8}, {"28", 9}]},
        {"grid_6.png", [{"20", 2}, {"17", 6}, {"23", 9}, {"15", 13}, {"10", 19}, {"19", 22}]},
        {"grid_7.png", [{"19", 2}, {"21", 4}, {"10", 5}, {"23", 11}, {"15", 13}]}
      ]
  """
  def driver(path \\ "images/") do
    # Getting the path of images
    image_path = path <> "*.png"
    # Creating a list of all images paths with extension .png
    image_list = Path.wildcard(image_path)

    # Parsing through all the images to get final output using the two funtions which teams need to complete
    Enum.map(image_list, fn x ->
      {String.trim_leading(x, path), identifyCellNumbers(x) |> identifyCellNumbersWithLocations}
    end)
  end
end

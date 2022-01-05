# User configured variables
$Locomotives = 3    # Max train queue
$S = 100            # Itemm stack size based on commodity type; eg Iron ore = 50, Iron Plate = 100, Green chip = 200 etc

# Dynamic Input Data from items
$StorageBoxes1 = 2200,2200,2200,2200
$StorageBoxes2 = 2200,2200,2200,2200
$StorageBoxes3 = 2200,2200,2200,2200
$StorageBoxes4 = 4800,4800,4800,4800

# Carraige 1 Circuits
# Constant Combinator to ensure output signal is always present
$StorageBoxes1Constant = 1
# Green Wire between boxes to Arithmatic Combinator
$StorageBoxes1GreenWire_Items = 0
$StorageBoxes1 | ForEach-Object { $StorageBoxes1GreenWire_Items += $_}
# Arithmatic Combinator converting to "1" signal, outputting to Red wire
$RedWire_1 = $StorageBoxes1GreenWire_Items + $StorageBoxes1Constant + 0


# Carraige 2 Circuits
# Constant Combinator to ensure output signal is always present
$StorageBoxes2Constant = 1
# Green Wire between boxes to Arithmatic Combinator
$StorageBoxes2GreenWire_Items = 0
$StorageBoxes2 | ForEach-Object { $StorageBoxes2GreenWire_Items += $_}
# Arithmatic Combinator converting to "2" signal, outputting to Red wire
$RedWire_2 = $StorageBoxes2GreenWire_Items + $StorageBoxes2Constant + 0


# Carraige 3 Circuits
# Constant Combinator to add one to ensure output signal is always present
$StorageBoxes3Constant = 1
# Green Wire between boxes to Arithmatic Combinator
$StorageBoxes3GreenWire_Items = 0
$StorageBoxes3 | ForEach-Object { $StorageBoxes3GreenWire_Items += $_}
# Arithmatic Combinator converting to "1" signal, outputting to Red wire
$RedWire_3 = $StorageBoxes3GreenWire_Items + $StorageBoxes3Constant + 0

# Carraige 4 Circuits
# Constant Combinator to ensure output signal is always present
$StorageBoxes4Constant = 1
# Green Wire between boxes to Arithmatic Combinator
$StorageBoxes4GreenWire_Items = 0
$StorageBoxes4 | ForEach-Object { $StorageBoxes4GreenWire_Items += $_}
# Arithmatic Combinator converting to "1" signal, outputting to Red wire
$RedWire_4 = $StorageBoxes4GreenWire_Items + $StorageBoxes4Constant + 0

# Red Wire between carriages
$RedWire = $RedWire_1, $RedWire_2, $RedWire_3, $RedWire_4

# Arithmatic Combinator to divide each of the carriage signals by Stack Size
[int[]]$StackDividerOutput = $RedWire | ForEach-Object { $_ / $S }

# Arithmatic Combinator to divide each of the carriage signals by the number of stacks available in a train carriage (40)
[int[]]$DeciderInputsRedWire = $StackDividerOutput | ForEach-Object { $_ / 40 }

# Decider Combinator to add one to each each carriage signal to ensure that each signal is always present
for ($i = 0; $i -lt $RedWire.Count; $i++) {
    $DeciderInputsRedWire[$i] ++
}

# Decider Combinators to calculate lowest number that appears in all signals (Everything signal greater than or equal to #number)
$DeciderOutputsGreenWire_T = 0
if (($DeciderInputsRedWire -ge 2).Count -eq $DeciderInputsRedWire.Count) { $DeciderOutputsGreenWire_T ++ }
if (($DeciderInputsRedWire -ge 3).Count -eq $DeciderInputsRedWire.Count) { $DeciderOutputsGreenWire_T ++ }
if (($DeciderInputsRedWire -ge 4).Count -eq $DeciderInputsRedWire.Count) { $DeciderOutputsGreenWire_T ++ }
if (($DeciderInputsRedWire -ge 5).Count -eq $DeciderInputsRedWire.Count) { $DeciderOutputsGreenWire_T ++ }
if (($DeciderInputsRedWire -ge 6).Count -eq $DeciderInputsRedWire.Count) { $DeciderOutputsGreenWire_T ++ }
if (($DeciderInputsRedWire -ge 7).Count -eq $DeciderInputsRedWire.Count) { $DeciderOutputsGreenWire_T ++ }
if (($DeciderInputsRedWire -ge 8).Count -eq $DeciderInputsRedWire.Count) { $DeciderOutputsGreenWire_T ++ }
if (($DeciderInputsRedWire -ge 9).Count -eq $DeciderInputsRedWire.Count) { $DeciderOutputsGreenWire_T ++ }
if (($DeciderInputsRedWire -ge 10).Count -eq $DeciderInputsRedWire.Count) { $DeciderOutputsGreenWire_T ++ }

# Decider Combinators to limit number of requested trains to Locomotive signal
if ($Locomotives -ge $DeciderOutputsGreenWire_T) { $LimiterOutput = $DeciderOutputsGreenWire_T }
if ($Locomotives -lt $DeciderOutputsGreenWire_T) { $LimiterOutput = $Locomotives }

# Arithmatic combinator to convert signal to L for train stop (Could be used to trim up or down train requests)
$L = $LimiterOutput + 0

# Train stop
$TrainLimit = $L

Write-Host $TrainLimit